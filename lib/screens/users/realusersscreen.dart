import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/models/users/Realusersmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/likeanddislikeprovider.dart';
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

      print("=== ROUTE ARGUMENTS DEBUG ===");
      print("accessToken: $accessToken");
      print("userId: $userId");
      print("modeId: $modeId");
      print("modeId type: ${modeId.runtimeType}");
      print("=============================");

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

  // Filter users based on modeId matching
List<Data> _getFilteredUsers(List<Data>? allUsers) {
  if (allUsers == null) return [];
  
  // DEBUG: Print information about filtering
  print("=== FILTERING DEBUG ===");
  print("Total users received: ${allUsers.length}");
  print("Mode ID to filter by: $modeId");
  
  if (modeId == null) {
    print("No modeId provided, returning all users");
    return allUsers;
  }
  
  List<Data> filteredUsers = [];
  
  for (int i = 0; i < allUsers.length; i++) {
    Data user = allUsers[i];
    print("\nUser ${i + 1}: ${user.firstName} ${user.lastName}");
    print("User modes: ${user.modes}");
    print("User modes type: ${user.modes.runtimeType}");
    print("User modes length: ${user.modes?.length ?? 0}");
    
    // NEW LOGIC: Include users with no modes OR users with matching modes
    if (user.modes == null || user.modes!.isEmpty) {
      print("✅ User has no modes - INCLUDED (assuming they match all modes)");
      filteredUsers.add(user);
      continue;
    }
    
    bool hasMatchingMode = false;
    for (var mode in user.modes!) {
      print("  Checking mode: $mode (type: ${mode.runtimeType})");
      
      if (mode is int) {
        if (mode == modeId) {
          hasMatchingMode = true;
          print("  ✅ Found matching int mode: $mode");
          break;
        }
      } else if (mode is Map<String, dynamic>) {
        var modeId_fromMap = mode;
        print("  Mode object id: $modeId_fromMap");
        if (modeId_fromMap == modeId) {
          hasMatchingMode = true;
          print("  ✅ Found matching object mode id: $modeId_fromMap");
          break;
        }
      } else if (mode is String) {
        try {
          int parsedMode = int.parse(mode as String);
          if (parsedMode == modeId) {
            hasMatchingMode = true;
            print("  ✅ Found matching string mode (parsed): $parsedMode");
            break;
          }
        } catch (e) {
          print("  ❌ Could not parse string mode: $mode");
        }
      }
    }
    
    if (hasMatchingMode) {
      filteredUsers.add(user);
      print("✅ User INCLUDED in filtered results");
    } else {
      print("❌ User EXCLUDED - no matching mode");
    }
  }
  
  print("\n=== FILTERING RESULTS ===");
  print("Filtered users count: ${filteredUsers.length}");
  print("=========================\n");
  
  return filteredUsers;
}

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(realusersprovider);
    final isLoading = ref.watch(loadingProvider);
    final provider = ref.read(realusersprovider.notifier);

    // Apply filtering based on modeId
    final filteredUsers = _getFilteredUsers(usersState.data);

    return Scaffold(
      backgroundColor: DatingColors.cardBackground,
      appBar: AppBar(
        title: Text('Users'),
        //  ${modeId != null ? "(Mode: $modeId)" : ""}
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => provider.refreshUsers(),
          ),
        ],
      ),
      body: isLoading && (filteredUsers.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : filteredUsers.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Users count info
                    // Container(
                    //   padding: EdgeInsets.all(16),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Filtered Users: ${filteredUsers.length}',
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       if (modeId != null)
                    //         Text(
                    //           'Mode ID: $modeId',
                    //           style: TextStyle(color: Colors.grey[600]),
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    // Users list
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => provider.refreshUsers(),
                        child: ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemCount: filteredUsers.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return _buildUserRow(user);
                          },
                        ),
                      ),
                    ),
                    // Pagination (Note: This might need adjustment for filtered results)
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
            modeId != null 
                ? 'No users found for Mode ID: $modeId'
                : 'No users found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Try refreshing or check if users exist for this mode',
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
    String baseUrl = "http://97.74.93.26:6100";
    String? imageUrl = user.profilePics?.isNotEmpty == true
        ? "$baseUrl${user.profilePics!.first.url}"
        : null;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DatingColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DatingColors.primaryGreen,
          width: 1.5,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo
          Container(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: imageUrl != null
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

          // User Info + Buttons in Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name and Mode info
                Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // Show user's modes
                if (user.modes != null && user.modes!.isNotEmpty)
                  Text(
                    'Modes: ${_getModesDisplay(user.modes)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                    ),
                  ),
                SizedBox(height: 8),

                // Buttons Row BELOW name
                Row(
                  children: [
                    // Dislike button
                    ElevatedButton(
                      onPressed: () => _handleDislike(user),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: DatingColors.errorRed,
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
            onPressed: currentPage > 1 ? () => _loadPage(currentPage - 1) : null,
            icon: Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: currentPage > 1
                  ? DatingColors.primaryGreen
                  : Colors.grey[300],
              foregroundColor:
                  currentPage > 1 ? Colors.white : Colors.grey[600],
            ),
          ),
          SizedBox(width: 8),

          // Scrollable page numbers
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(totalPages, (index) {
                  int pageNumber = index + 1;
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
                }),
              ),
            ),
          ),

          SizedBox(width: 8),
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

  // Helper method to display modes
  String _getModesDisplay(List<dynamic>? modes) {
    if (modes == null || modes.isEmpty) return 'None';
    
    return modes.map((mode) {
      if (mode is int) {
        return mode.toString();
      } else if (mode is Map<String, dynamic>) {
        return mode['id']?.toString() ?? mode.toString();
      }
      return mode.toString();
    }).join(', ');
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
    ref.read(likeanddislikeprovider.notifier).addLikeDislike(
              specificToken: accessToken,
              realuserid:user.id,
              swipedirection:"right"
              
            );
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
    ref.read(likeanddislikeprovider.notifier).addLikeDislike(
              specificToken: accessToken,
              realuserid:user.id,
              swipedirection:"left"
              
            );
  }

  void _showUserDetails(Data user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserCard(user: user),
    );
  }
}

// User Details Modal
class UserCard extends StatelessWidget {
  final Data user;
  final String baseUrl = "http://97.74.93.26:6100";

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile pics carousel
              if (user.profilePics != null && user.profilePics!.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: user.profilePics!.length,
                    itemBuilder: (context, index) {
                      final photo = user.profilePics![index];
                      final photoUrl = "$baseUrl${photo.url ?? ''}";
          
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: const Icon(Icons.person, size: 80, color: Colors.grey),
                ),
          
              const SizedBox(height: 12),
          
              // User basic info with Modes
              Text(
                '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (user.modes != null && user.modes!.isNotEmpty)
                Text(
                  'Modes: ${_getModesDisplay(user.modes)}',
                  style: TextStyle(fontSize: 16, color: Colors.blue[600]),
                ),
              if (user.dob != null)
                Text(
                  'Age: ${_calculateAge(user.dob!)}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              SizedBox(height: 16),
              
              // Work and Education
              if (user.work != null)
                _buildInfoSection('Work', '${user.work!.title ?? ''} at ${user.work!.company ?? ''}'),
              if (user.education != null)
                _buildInfoSection('Education', user.education!.institution ?? ''),
              if (user.location != null)
                _buildInfoSection('Location', user.location!.name ?? ''),
              
              // Interests
              if (user.interests?.isNotEmpty == true)
                _buildListSection('Interests', user.interests!.map((e) => e.interests ?? '').toList()),
              
              // Qualities
              if (user.qualities?.isNotEmpty == true)
                _buildListSection('Qualities', user.qualities!.map((e) => e.name ?? '').toList()),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to display modes
  String _getModesDisplay(List<dynamic>? modes) {
    if (modes == null || modes.isEmpty) return 'None';
    
    return modes.map((mode) {
      if (mode is int) {
        return mode.toString();
      } else if (mode is Map<String, dynamic>) {
        return mode['id']?.toString() ?? mode.toString();
      }
      return mode.toString();
    }).join(', ');
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