import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/models/users/otheruserlikedpersonsmodel.dart';
import 'package:admin_dating/provider/users/otheruserslikedpersonsprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedpeoplesScreen extends ConsumerStatefulWidget {
  const LikedpeoplesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LikedpeoplesScreen> createState() =>
      _LikedpeoplesScreenState();
}

class _LikedpeoplesScreenState extends ConsumerState<LikedpeoplesScreen>
    with SingleTickerProviderStateMixin {
  String? accessToken;
  dynamic userId;
  TabController? _tabController;

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

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      try {
        accessToken = args['accessToken'] as String?;
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
    if (accessToken != null) {
      print('Fetching with token: $accessToken');
      ref.read(likedUsersprovider.notifier).getLikedUsers(
            specificToken: accessToken,
          );
    } else {
      ref.read(likedUsersprovider.notifier).getLikedUsers();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final likesDislikesState = ref.watch(likedUsersprovider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: DatingColors.surfaceGrey,
      appBar: AppBar(
        title: const Text(
          'Liked peoples',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DatingColors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: DatingColors.primaryGreen,
              ),
            )
          : likesDislikesState.data == null || likesDislikesState.data!.isEmpty
              ? _buildEmptyState()
              : _buildUsersList(likesDislikesState.data!),
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
            'No liked users yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<Data> users) {
    return RefreshIndicator(
      onRefresh: _initializeAndFetchData,
      color: DatingColors.primaryGreen,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(Data user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // User Image
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: user.image != null && user.image!.isNotEmpty
                  ? Image.network(
                      user.image!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderAvatar(user.firstName);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    )
                  : _buildPlaceholderAvatar(user.firstName),
            ),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.firstName ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (user.lastName != null && user.lastName!.isNotEmpty)
                    Text(
                      user.lastName!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 14,
                        color: DatingColors.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(user.likedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(String? name) {
    final initial = name != null && name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: DatingColors.primaryGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: DatingColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }
}