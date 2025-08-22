import 'package:admin_dating/models/users/Realusersmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/realusersprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Real Users Screen
class RealUsersScreen extends ConsumerStatefulWidget {
  @override
  _RealUsersScreenState createState() => _RealUsersScreenState();
}

class _RealUsersScreenState extends ConsumerState<RealUsersScreen> {
  ScrollController _scrollController = ScrollController();
  String? accessToken;
  int? userId;
  int? modeId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments from route
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      accessToken = args['accessToken'];
      userId = args['userId'];
      modeId = args['modeId'];

      // Initial load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(realusersprovider.notifier).getRealusers(
              specificToken: accessToken,
              modeId: modeId,
            );
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when scrolled to 80%
      ref.read(realusersprovider.notifier).loadMoreUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(realusersprovider);
    final isLoading = ref.watch(loadingProvider);
    final provider = ref.read(realusersprovider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => provider.refreshUsers(),
          ),
        ],
      ),
      body: isLoading && (usersState.data?.isEmpty ?? true)
          ? Center(child: CircularProgressIndicator())
          : usersState.data == null || usersState.data!.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => provider.refreshUsers(),
                  child: Column(
                    children: [
                      // Users count and pagination info
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Users: ${usersState.pagination?.total ?? 0}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Page ${usersState.pagination?.page ?? 1} of ${usersState.pagination?.totalPages ?? 1}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      // Users grid
                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: usersState.data!.length +
                              (provider.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == usersState.data!.length) {
                              // Loading indicator at the end
                              return provider.isLoadingMore
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox();
                            }

                            final user = usersState.data![index];
                            return _buildUserCard(user);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Try refreshing or check back later',
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                ref.read(realusersprovider.notifier).refreshUsers(),
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade400,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Data user) {
    final primaryPhoto = user.profilePics?.firstWhere(
      (pic) => pic.isPrimary == true,
      orElse: () => user.profilePics?.isNotEmpty == true
          ? user.profilePics!.first
          : ProfilePics(),
    );
    print('photo..............$primaryPhoto');

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: primaryPhoto?.url != null
                      ? CachedNetworkImage(
                          imageUrl: primaryPhoto!.url!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,
                                    size: 40, color: Colors.grey[400]),
                                Text('No Image',
                                    style: TextStyle(color: Colors.grey[500])),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person,
                                  size: 40, color: Colors.grey[400]),
                              Text('No Image',
                                  style: TextStyle(color: Colors.grey[500])),
                            ],
                          ),
                        ),
                ),
                // Verified badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified, color: Colors.white, size: 16),
                  ),
                ),
                // Age badge
                if (user.dob != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_calculateAge(user.dob!)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // User info section
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Location or work
                  if (user.location?.name != null)
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location!.name!,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (user.work?.title != null)
                    Row(
                      children: [
                        Icon(Icons.work, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.work!.title!,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  Spacer(),
                  // Action buttons
                  Row(
                    children: [
                      // Dislike button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleDislike(user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Icon(Icons.close, size: 20),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Like button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleLike(user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Icon(Icons.favorite, size: 20),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Details button
                      ElevatedButton(
                        onPressed: () => _showUserDetails(user),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        child: Icon(Icons.arrow_forward, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  void _handleLike(Data user) {
    // Implement like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${user.firstName ?? 'User'}'),
        backgroundColor: Colors.pink.shade400,
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Make API call to like user
  }

  void _handleDislike(Data user) {
    // Implement dislike functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passed ${user.firstName ?? 'User'}'),
        backgroundColor: Colors.grey[600],
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Make API call to dislike user
  }

  void _showUserDetails(Data user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserDetailsModal(user: user),
    );
  }
}

// User Details Modal
class UserDetailsModal extends StatelessWidget {
  final Data user;

  const UserDetailsModal({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Profile photos carousel
                  if (user.profilePics?.isNotEmpty == true)
                    Container(
                      height: 300,
                      child: PageView.builder(
                        itemCount: user.profilePics!.length,
                        itemBuilder: (context, index) {
                          final photo = user.profilePics![index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: photo.url ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 20),
                  // User details
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (user.dob != null)
                    Text(
                      'Age: ${_calculateAge(user.dob!)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  SizedBox(height: 16),

                  // Work and Education
                  if (user.work != null)
                    _buildInfoSection('Work',
                        '${user.work!.title ?? ''} at ${user.work!.company ?? ''}'),
                  if (user.education != null)
                    _buildInfoSection(
                        'Education', user.education!.institution ?? ''),
                  if (user.location != null)
                    _buildInfoSection('Location', user.location!.name ?? ''),

                  // Interests
                  if (user.interests?.isNotEmpty == true)
                    _buildListSection('Interests',
                        user.interests!.map((e) => e.interests ?? '').toList()),

                  // Qualities
                  if (user.qualities?.isNotEmpty == true)
                    _buildListSection('Qualities',
                        user.qualities!.map((e) => e.name ?? '').toList()),

                  SizedBox(height: 80), // Space for floating action buttons
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, String content) {
    if (content.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(content,
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    if (items.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items
                .map((item) => Chip(
                      label: Text(item, style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey[100],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }
}
