import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/likeanddislikeprovider.dart';
import 'package:admin_dating/models/users/likeansdislikemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LikesDislikesScreen extends ConsumerStatefulWidget {
  const LikesDislikesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LikesDislikesScreen> createState() => _LikesDislikesScreenState();
}

class _LikesDislikesScreenState extends ConsumerState<LikesDislikesScreen>
    with SingleTickerProviderStateMixin {
  String? accessToken;
  int? userId;
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
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      accessToken = args['accessToken'];
      userId = args['userId'];
      print('Received Access Token: $accessToken');
      print('Received User ID: $userId');
    }
  }

  Future<void> _initializeAndFetchData() async {
    await _setAccessTokenInPreferences();
    ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
  }

  Future<void> _setAccessTokenInPreferences() async {
    if (accessToken != null) {
      final prefs = await SharedPreferences.getInstance();
      
      // Create user data structure similar to your login response
      final userData = {
        'accessToken': accessToken,
        'data': [
          {
            'access_token': accessToken,
            'user_id': userId ?? 'unknown'
          }
        ]
      };
      
      await prefs.setString('userData', jsonEncode(userData));
      print('Access token set in SharedPreferences for API calls');
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
            color: DatingColors.White,
            fontSize: 24,
          ),
        ),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: DatingColors.White,
          labelColor: DatingColors.White,
          unselectedLabelColor: DatingColors.White.withOpacity(0.7),
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
        actions: [
          if (accessToken != null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Token Active',
                style: TextStyle(
                  color: DatingColors.White,
                  fontSize: 12,
                ),
              ),
            ),
        ],
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
          ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
        },
        backgroundColor: DatingColors.darkGreen,
        child: const Icon(Icons.refresh, color: DatingColors.White),
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
        ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
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
        ref.read(likeanddislikeprovider.notifier).getLikeanddislike();
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
          color: isLiked ? Colors.red : Colors.grey,
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
                  const SizedBox(height: 8),
                  _buildUserDetails(user),
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

  Widget _buildUserDetails(TargetUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.email?.isNotEmpty == true)
          Row(
            children: [
              Icon(Icons.email_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        if (user.gender?.isNotEmpty == true || user.age != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                '${user.gender ?? 'Unknown'}, ${user.age ?? 'Unknown'} years',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
        if (user.bio?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            user.bio!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
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