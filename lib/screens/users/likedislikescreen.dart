
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/likeanddislikeprovider.dart';
import 'package:admin_dating/models/users/likeansdislikemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LikesDislikesScreen extends ConsumerStatefulWidget {
  const LikesDislikesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LikesDislikesScreen> createState() => _LikesDislikesScreenState();
}

class _LikesDislikesScreenState extends ConsumerState<LikesDislikesScreen>
    with SingleTickerProviderStateMixin {
  String? accessToken;
  dynamic userId; // Changed to dynamic to handle both int and String
  TabController? _tabController;
  
  List<Data> likedUsers = [];
  List<Data> dislikedUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndFetchData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments passed from previous screen
    final args = ModalRoute.of(context)?.settings.arguments;
    
    if (args is Map<String, dynamic>) {
      try {
        accessToken = args['accessToken'] as String?;
        // Handle userId safely - it could be int, String, or null
        final userIdValue = args['userId'];
        if (userIdValue != null) {
          userId = userIdValue;
        }
        print('Received Access Token: $accessToken');
        print('Received User ID: $userId (Type: ${userId.runtimeType})');
      } catch (e) {
        print('Error parsing arguments: $e');
      }
    }
  }

  Future<void> _initializeAndFetchData() async {
    // Don't set token in SharedPreferences, just use it directly
    if (accessToken != null) {
      print('Fetching likes/dislikes with token: $accessToken');
      // Pass the access token directly to the provider
      ref.read(likeanddislikeprovider.notifier).getLikeanddislike(
        specificToken: accessToken,
      );
    } else {
      // Fallback to using token from SharedPreferences
      ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
    }
  }

  

  void _filterLikesAndDislikes(List<Data> data) {
    likedUsers.clear();
    dislikedUsers.clear();
    
    for (var item in data) {
      if (item.action?.toLowerCase() == 'like') {
        likedUsers.add(item);
      } else if (item.action?.toLowerCase() == 'dislike') {
        dislikedUsers.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final likesDislikesState = ref.watch(likeanddislikeprovider);
    final isLoading = ref.watch(loadingProvider);

    // Filter data when state changes
    if (likesDislikesState.data != null) {
      _filterLikesAndDislikes(likesDislikesState.data!);
    }

    return Scaffold(
      backgroundColor: DatingColors.surfaceGrey,
      appBar: AppBar(
        title: const Text(
          'Likes & Dislikes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DatingColors.white,
            fontSize: 24,
          ),
        ),
         actions: [
            IconButton(
              onPressed: () {
                // Add user functionality
                // _showAddUserDialog(context);
                Navigator.pushNamed(
                  context,
                  '/likedpeoplesscreen',
                  arguments: {
                'accessToken': accessToken,
               
                'userId':userId
              },
                );
                
              },
              icon: const Icon(
                Icons.favorite_outlined,
                color: DatingColors.white,
                size: 48,
              ),
            ),
            const SizedBox(width: 8),
          ],
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: DatingColors.white,
          labelColor: DatingColors.lightpink,
          unselectedLabelColor: DatingColors.white.withOpacity(0.7),
          tabs: [
            Tab(
              icon: const Icon(Icons.favorite),
              text: 'Liked (${likedUsers.length})',
            ),
            Tab(
              icon: const Icon(Icons.heart_broken),
              text: 'Disliked (${dislikedUsers.length})',
            ),
          ],
        ),
       
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: DatingColors.darkGreen,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLikedUsersTab(),
                _buildDislikedUsersTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Use the passed access token for refresh as well
          if (accessToken != null) {
            ref.read(likeanddislikeprovider.notifier).getLikeanddislike(
              specificToken: accessToken,
            );
          } else {
            ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
          }
        },
        backgroundColor: DatingColors.darkGreen,
        child: const Icon(Icons.refresh, color: DatingColors.white),
      ),
    );
  }

  Widget _buildLikedUsersTab() {
    if (likedUsers.isEmpty) {
      return _buildEmptyState(
        icon: Icons.favorite_border,
        title: 'No Liked Users',
        subtitle: 'Users you liked will appear here',
      );
    }

    return RefreshIndicator(
      color: Colors.red,
      onRefresh: () async {
        if (accessToken != null) {
          ref.read(likeanddislikeprovider.notifier).getLikeanddislike(
            specificToken: accessToken,
          );
        } else {
          ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: likedUsers.length,
        itemBuilder: (context, index) {
          final likedUser = likedUsers[index];
          return _buildUserCard(likedUser, isLiked: true);
        },
      ),
    );
  }

  Widget _buildDislikedUsersTab() {
    if (dislikedUsers.isEmpty) {
      return _buildEmptyState(
        icon: Icons.heart_broken_outlined,
        title: 'No Disliked Users',
        subtitle: 'Users you disliked will appear here',
      );
    }

    return RefreshIndicator(
      color: Colors.grey,
      onRefresh: () async {
        if (accessToken != null) {
          ref.read(likeanddislikeprovider.notifier).getLikeanddislike(
            specificToken: accessToken,
          );
        } else {
          ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dislikedUsers.length,
        itemBuilder: (context, index) {
          final dislikedUser = dislikedUsers[index];
          return _buildUserCard(dislikedUser, isLiked: false);
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Data userData, {required bool isLiked}) {
    final user = userData.targetUser;
    if (user == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLiked ? DatingColors.darkGreen : Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Profile Image
            _buildProfileImage(user),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserName(user),
                  // const SizedBox(height: 8),
                  // _buildUserDetails(user),
                  const SizedBox(height: 12),
                  _buildActionInfo(userData, isLiked),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(TargetUser user) {
    String baseUrl = "http://97.74.93.26:6100";
    String? imageUrl = user.photoUrl?.isNotEmpty == true
        ? (user.photoUrl!.startsWith('http') 
            ? user.photoUrl! 
            : "$baseUrl${user.photoUrl!}")
        : null;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: DatingColors.primaryGreen,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar(user);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              )
            : _buildDefaultAvatar(user),
      ),
    );
  }

  Widget _buildDefaultAvatar(TargetUser user) {
    String initials = '';
    if (user.firstName?.isNotEmpty == true) {
      initials = user.firstName![0].toUpperCase();
      if (user.lastName?.isNotEmpty == true) {
        initials += user.lastName![0].toUpperCase();
      }
    }

    return Container(
      color: Colors.deepPurple.withOpacity(0.1),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildUserName(TargetUser user) {
    String fullName = '';
    if (user.firstName?.isNotEmpty == true) {
      fullName = user.firstName!;
      if (user.lastName?.isNotEmpty == true) {
        fullName += ' ${user.lastName!}';
      }
    }

    return Text(
      fullName.isNotEmpty ? fullName : user.username ?? 'Unknown User',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

 

  Widget _buildActionInfo(Data userData, bool isLiked) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isLiked 
                ? Colors.red.withOpacity(0.1) 
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLiked 
                  ? Colors.red.withOpacity(0.3) 
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.heart_broken,
                size: 16,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                isLiked ? 'Liked' : 'Disliked',
                style: TextStyle(
                  fontSize: 12,
                  color: isLiked ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (userData.createdAt?.isNotEmpty == true)
          Text(
            _formatDate(userData.createdAt!),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}