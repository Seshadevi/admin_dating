import 'package:admin_dating/constants/dating_colors.dart';
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
  String? accessToken;
  int? userId;
  int? modeId;
  int currentPage = 1;

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

  void _loadPage(int page) {
    setState(() {
      currentPage = page;
    });
    // Load specific page
    ref.read(realusersprovider.notifier).loadPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(realusersprovider);
    final isLoading = ref.watch(loadingProvider);
    final provider = ref.read(realusersprovider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: DatingColors.primaryGreen,
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
              : Column(
                  children: [
                    // Users count info
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // children: [
                        //   Text(
                        //     'Total Users: ${usersState.pagination?.total ?? 0}',
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        //   Text(
                        //     'Page $currentPage of ${usersState.pagination?.totalPages ?? 1}',
                        //     style: TextStyle(color: Colors.grey[600]),
                        //   ),
                        // ],
                      ),
                    ),
                    // Users list
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => provider.refreshUsers(),
                        child: ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemCount: usersState.data!.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = usersState.data![index];
                            return _buildUserRow(user);
                          },
                        ),
                      ),
                    ),
                    // Pagination
                    if (usersState.pagination != null &&
                        (usersState.pagination?.totalPages ?? 0) > 1)
                      _buildPagination(usersState.pagination!.totalPages!),
                  ],
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
              backgroundColor: DatingColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(Data user) {
    // final primaryPhoto = user.profilePics?.firstWhere(
    //   (pic) => pic.isPrimary == true,
    //   orElse: () => user.profilePics?.isNotEmpty == true
    //       ? user.profilePics!.first
    //       : ProfilePics(),
    // );
    String baseUrl = "http://97.74.93.26:6100";
    String? imageUrl = user.profilePics?.isNotEmpty == true
    ? "$baseUrl${user.profilePics!.first.url}"  // 👈 prepend base URL
    : null;
    // print('primaryphoto.......$primaryPhoto');
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Photo
          Container(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: imageUrl!= null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[400]),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.grey[400]),
                    ),
            ),
          ),
          SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // SizedBox(height: 4),
                // if (user.dob != null)
                //   Text(
                //     'Age: ${_calculateAge(user.dob!)}',
                //     style: TextStyle(color: Colors.grey[600], fontSize: 14),
                //   ),
                // if (user.location?.name != null)
                //   Text(
                //     user.location!.name!,
                //     style: TextStyle(color: Colors.grey[500], fontSize: 12),
                //   ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            children: [
              // Dislike button
              ElevatedButton(
                onPressed: () => _handleDislike(user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(8),
                  minimumSize: Size(40, 40),
                ),
                child: Icon(Icons.close, size: 20),
              ),
              SizedBox(width: 8),
              // Like button
              ElevatedButton(
                onPressed: () => _handleLike(user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DatingColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(8),
                  minimumSize: Size(40, 40),
                ),
                child: Icon(Icons.favorite, size: 20),
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
                  minimumSize: Size(40, 40),
                ),
                child: Icon(Icons.arrow_forward, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            onPressed:
                currentPage > 1 ? () => _loadPage(currentPage - 1) : null,
            icon: Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: currentPage > 1
                  ? DatingColors.primaryGreen
                  : Colors.grey[300],
              foregroundColor:
                  currentPage > 1 ? Colors.white : Colors.grey[600],
            ),
          ),
          SizedBox(width: 16),
          // Page numbers
          ...List.generate(
            totalPages > 5 ? 5 : totalPages,
            (index) {
              int pageNumber;
              if (totalPages <= 5) {
                pageNumber = index + 1;
              } else {
                // Show pages around current page
                int start = currentPage - 2;
                if (start < 1) start = 1;
                if (start + 4 > totalPages) start = totalPages - 4;
                pageNumber = start + index;
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () => _loadPage(pageNumber),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage == pageNumber
                        ? DatingColors.primaryGreen
                        : Colors.white,
                    foregroundColor: currentPage == pageNumber
                        ? Colors.white
                        : DatingColors.primaryGreen,
                    side: BorderSide(color: DatingColors.primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('$pageNumber'),
                ),
              );
            },
          ),
          SizedBox(width: 16),
          // Next button
          IconButton(
            onPressed: currentPage < totalPages
                ? () => _loadPage(currentPage + 1)
                : null,
            icon: Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: currentPage < totalPages
                  ? DatingColors.primaryGreen
                  : Colors.grey[300],
              foregroundColor:
                  currentPage < totalPages ? Colors.white : Colors.grey[600],
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${user.firstName ?? 'User'}'),
        backgroundColor: DatingColors.primaryGreen,
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Make API call to like user
  }

  void _handleDislike(Data user) {
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

// User Details Modal (keeping the same)
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

                  SizedBox(height: 80),
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
