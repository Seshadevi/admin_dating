import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/users/matchesprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:admin_dating/provider/matchesprovider.dart';
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
          ' Matches',
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
          : matchesState.data == null || matchesState.data!.isEmpty
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
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: matchedUsers.length,
        itemBuilder: (context, index) {
          final match = matchedUsers[index];
          final user = match.matchedUser;
          
          if (user == null) return const SizedBox.shrink();
          
          return _buildMatchCard(user, match);
        },
      ),
    );
  }

  Widget _buildMatchCard(MatchedUser user, Data match) {
    final String displayName = _getDisplayName(user);
    final String photoUrl = user.photoUrl ?? '';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
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
          ),
          
          // Name Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(height: 4),
                  Container(
                    width: 30,
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
    if (user.firstName != null && user.firstName!.isNotEmpty) {
      if (user.lastName != null && user.lastName!.isNotEmpty) {
        return '${user.firstName} ${user.lastName}';
      }
      return user.firstName!;
    }
    
    if (user.username != null && user.username!.isNotEmpty) {
      return user.username!;
    }
    
    return 'Unknown User';
  }
}