





import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/users/matchesprovider.dart';
import 'package:admin_dating/screens/users/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dating/provider/loader.dart';

import '../../models/users/Matchesmodel.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  String? accessToken;
  int? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments passed from navigation
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      accessToken = arguments['accessToken'] as String?;
      userId = arguments['userId'] as int?;
      
      // Fetch matches using the provided access token
      if (accessToken != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(matchesprovider.notifier).getMatches(specificToken: accessToken);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchesState = ref.watch(matchesprovider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: DatingColors.darkGreen,
        foregroundColor: DatingColors.cardBackground,
        title: const Text(
          'Matches',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DatingColors.cardBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(DatingColors.cardBackground),
              ),
            )
          : (matchesState.data == null || matchesState.data!.isEmpty)
              ? _buildEmptyState()
              : _buildMatchesList(matchesState.data!),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Matches Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep swiping to find your perfect match!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList(List<Data> matches) {
    // Filter only matched status
    final matchedUsers = matches.where((match) => match.status == 'matched').toList();
    
    if (matchedUsers.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: matchedUsers.length,
        itemBuilder: (context, index) {
          final match = matchedUsers[index];
          final user = match.matchedUser;
          
          if (user == null) return const SizedBox.shrink();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildMatchCard(user, match),
          );
        },
      ),
    );
  }

  Widget _buildMatchCard(MatchedUser user, Data match) {
    final String displayName = _getDisplayName(user);
    final String photoUrl = user.photoUrl ?? '';
    
    return Container(
      height: 120, // Fixed height for ListView items
      decoration: BoxDecoration(
        color: DatingColors.lightGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DatingColors.darkGreen),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: photoUrl.isNotEmpty
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(displayName);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(DatingColors.darkGreen),
                            ),
                          ),
                        );
                      },
                    )
                  : _buildDefaultAvatar(displayName),
            ),
          ),
          
          // Name and Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (user.gender != null)
                    Text(
                      user.gender!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      color: DatingColors.darkGreen,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Button → open chat
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (accessToken == null || accessToken!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Missing access token for chat')),
                  );
                  return;
                }
                if (user.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid user id')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminChatScreen(
                      accessToken: accessToken!,           // from MatchesScreen state
                      peerUserId: user.id!,                // user to chat with
                      peerName: _getDisplayName(user),
                      avatar: user.photoUrl ?? '',
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_bubble_outline,
                color: DatingColors.black,
                size: 24,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Container(
      color: DatingColors.cardBackground,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: DatingColors.darkGreen,
          ),
        ),
      ),
    );
  }

  String _getDisplayName(MatchedUser user) {
    // Use null-safe operators instead of null check operators
    final firstName = user.firstName;
    final lastName = user.lastName;
    final username = user.username;
    
    if (firstName != null && firstName.isNotEmpty) {
      if (lastName != null && lastName.isNotEmpty) {
        return '$firstName $lastName';
      }
      return firstName;
    }
    
    if (username != null && username.isNotEmpty) {
      return username;
    }
    
    return 'Unknown User';
  }
}