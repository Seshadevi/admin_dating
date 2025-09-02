import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/models/users/Realusersmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/likeanddislikeprovider.dart';
import 'package:admin_dating/provider/users/realusersprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Real Users Screen with Enhanced Mode Filtering
class RealUsersScreen extends ConsumerStatefulWidget {
  @override
  _RealUsersScreenState createState() => _RealUsersScreenState();
}

class _RealUsersScreenState extends ConsumerState<RealUsersScreen> {
  String? accessToken;
  int? userId;
  int? modeId;
  int currentPage = 1;
  static const int itemsPerPage = 30; // Adjust as needed

  // For client-side pagination
  List<Data> allFilteredUsers = [];
  bool isLoadingMore = false;
  bool hasMorePages = true;

  // Add these variables to track pagination info
  int totalBackendUsers = 0;
  int totalBackendPages = 0;

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
      print("itemsPerPage: $itemsPerPage");
      print("=============================");

      // Validate modeId
      if (modeId == null) {
        _showErrorDialog("Mode ID is required to filter users");
        return;
      }

      // Initial load - fetch multiple pages to get enough filtered data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMultiplePagesForFiltering();
      });
    } else {
      _showErrorDialog("Missing required parameters");
    }
  }

  // Load multiple pages from backend to get enough data for client-side filtering
  Future<void> _loadMultiplePagesForFiltering() async {
    if (accessToken == null || modeId == null) {
      print("ERROR: Missing accessToken or modeId");
      return;
    }

    setState(() {
      isLoadingMore = true;
      allFilteredUsers.clear();
    });

    print("=== LOADING MULTIPLE PAGES FOR FILTERING ===");

    try {
      // Load multiple pages to get enough filtered data
      for (int page = 1; page <= 5; page++) {
        // Load first 5 pages
        await _loadSinglePageAndFilter(page);

        // If we have enough filtered users for current page, we can stop
        if (allFilteredUsers.length >= currentPage * itemsPerPage) {
          break;
        }
      }

      print("Total filtered users loaded: ${allFilteredUsers.length}");
    } catch (e) {
      print("Error loading pages: $e");
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> _loadSinglePageAndFilter(int page) async {
    print("Loading backend page: $page");

    // Load users from this page
    await ref.read(realusersprovider.notifier).getRealusers(
          specificToken: accessToken,
          modeId: null, // Don't filter on backend, do client-side filtering
          page: page,
          // limit: 50, // Get more users per page to increase chances of matches
        );

    // Get the loaded users and pagination info
    final usersState = ref.read(realusersprovider);
    final pageUsers = usersState.data ?? [];

    // Update backend pagination info
    if (usersState.pagination != null) {
      totalBackendUsers = usersState.pagination!.total ?? 0;
      totalBackendPages = usersState.pagination!.totalPages ?? 1;
    }

    // Filter users by modeId
    final filteredPageUsers = pageUsers.where((user) {
      return user.modes?.any((mode) => mode.id == modeId) ?? false;
    }).toList();

    print(
        "Page $page: ${pageUsers.length} total users, ${filteredPageUsers.length} matching mode $modeId");

    // Add to our filtered collection (avoid duplicates)
    for (final user in filteredPageUsers) {
      if (!allFilteredUsers.any((existingUser) => existingUser.id == user.id)) {
        allFilteredUsers.add(user);
      }
    }

    // Check if backend has more pages
    if (page >= totalBackendPages) {
      hasMorePages = false;
    }
  }

  void _loadUsersWithModeFilter(int page) {
    // This method is now used for refresh
    _loadMultiplePagesForFiltering();
  }

  void _loadAllUsers(int page) {
    if (accessToken == null) {
      print("ERROR: Missing accessToken");
      return;
    }

    print("=== LOADING ALL USERS (DEBUG) ===");
    print("Loading page: $page");
    print("Without mode filtering");
    print("==================================");

    // Load users without mode filtering for debugging
    ref.read(realusersprovider.notifier).getRealusers(
          specificToken: accessToken,
          modeId: null, // No mode filtering
          page: page,
          // limit: itemsPerPage,
        );
  }

  void _loadPage(int page) {
    if (page < 1) return;

    setState(() {
      currentPage = page;
    });

    // Check if we need to load more data from backend
    int requiredUsers = page * itemsPerPage;

    if (allFilteredUsers.length < requiredUsers && hasMorePages) {
      // Need to load more pages from backend
      _loadMorePagesForPagination(page);
    }
  }

  Future<void> _loadMorePagesForPagination(int targetPage) async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      // Calculate how many more backend pages we might need
      int currentBackendPage = (allFilteredUsers.length ~/ 20) +
          1; // Assuming ~20 users per backend page
      int maxPagesToLoad = currentBackendPage + 10; // Load up to 10 more pages

      for (int page = currentBackendPage;
          page <= maxPagesToLoad && hasMorePages;
          page++) {
        await _loadSinglePageAndFilter(page);

        // If we have enough for the target page, stop
        if (allFilteredUsers.length >= targetPage * itemsPerPage) {
          break;
        }
      }
    } catch (e) {
      print("Error loading more pages: $e");
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(realusersprovider);
    final isLoading = ref.watch(loadingProvider);

    // Use our filtered collection instead of backend data
    final allUsers = allFilteredUsers;

    // Calculate pagination for filtered data
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, allUsers.length);

    // Get users for current page
    final users =
        allUsers.sublist(startIndex.clamp(0, allUsers.length), endIndex);

    // Calculate total pages based on filtered data
    int totalFilteredPages = (allUsers.length / itemsPerPage).ceil();
    if (totalFilteredPages == 0) totalFilteredPages = 1;

    // Debug print
    print("=== PAGINATION DEBUG ===");
    print("Total filtered users: ${allUsers.length}");
    print("Current page: $currentPage");
    print("Users on this page: ${users.length}");
    print("Start index: $startIndex, End index: $endIndex");
    print("Total filtered pages: $totalFilteredPages");
    print("Is loading more: $isLoadingMore");
    print("========================");

    return Scaffold(
      backgroundColor: DatingColors.cardBackground,
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () => _loadUsersWithModeFilter(currentPage),
          // ),
          // // Add debug info button
          // IconButton(
          //   icon: Icon(Icons.info_outline),
          //   onPressed: () => _showDebugInfo(
          //       users.length, totalBackendUsers, totalBackendPages),
          // ),
          // Add option to load all users (for debugging)
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Load All Users (Debug)'),
                value: 'load_all',
              ),
              PopupMenuItem(
                child: Text('Load Mode Filtered'),
                value: 'load_filtered',
              ),
            ],
            onSelected: (value) {
              if (value == 'load_all') {
                _loadAllUsers(currentPage);
              } else if (value == 'load_filtered') {
                _loadUsersWithModeFilter(currentPage);
              }
            },
          ),
        ],
      ),
      body: isLoading && users.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading users '),
                ],
              ),
            )
          : users.isEmpty
              ? _buildEmptyState(totalFilteredPages)
              : Column(
                  children: [
                    // Enhanced users count info with pagination details
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mode $modeId Users',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Total: $totalBackendUsers',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          // SizedBox(height: 8),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Page $currentPage of $totalFilteredPages',
                          //       style: TextStyle(
                          //         color: Colors.grey[600],
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //     Text(
                          //       'Showing ${users.length} users',
                          //       style: TextStyle(
                          //         color: Colors.grey[600],
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),

                    // Users list
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async =>
                            _loadUsersWithModeFilter(currentPage),
                        child: ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemCount: users.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return _buildUserRow(user, index);
                          },
                        ),
                      ),
                    ),

                    // Enhanced Pagination
                    if (totalFilteredPages > 1)
                      _buildEnhancedPagination(totalFilteredPages),
                  ],
                ),
    );
  }

  Widget _buildEmptyState(int totalFilteredPages) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No users found with Mode ID: $modeId',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Backend may not be filtering properly.\nUsing client-side filtering as backup.',
            style: TextStyle(
                color: Colors.orange[600], fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Page $currentPage has no matching users.\nTry refreshing or check other pages.',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _loadUsersWithModeFilter(currentPage),
                icon: Icon(Icons.refresh),
                label: Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DatingColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              if (currentPage > 1)
                ElevatedButton.icon(
                  onPressed: () => _loadPage(1),
                  icon: Icon(Icons.first_page),
                  label: Text('First Page'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          // Debug button to show all users
          ElevatedButton.icon(
            onPressed: () => _showAllUsersDebug(),
            icon: Icon(Icons.bug_report),
            label: Text('Debug: Show All Users'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(Data user, int index) {
    String baseUrl = "http://97.74.93.26:6100";
    String? imageUrl = user.profilePics?.isNotEmpty == true
        ? "$baseUrl${user.profilePics!.first.url}"
        : null;

    // Calculate global index for display
    int globalIndex = ((currentPage - 1) * itemsPerPage) + index + 1;

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
          // Profile Photo with index
          Stack(
            children: [
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
              // Index badge
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: DatingColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    // '$globalIndex'
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
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
                // Show user's modes with highlight for matching mode
                if (user.modes != null && user.modes!.isNotEmpty)
                  Text(
                    'Mode: ${_getModesDisplayWithHighlight(user.modes)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                    ),
                  ),
                // Show user ID for debugging
                // Text(
                //   'ID: ${user.id}',
                //   style: TextStyle(
                //     fontSize: 10,
                //     color: Colors.grey[500],
                //   ),
                // ),
                // SizedBox(height: 8),

                // Buttons Row BELOW name
                Row(
                  children: [
                    // Dislike button
                    ElevatedButton(
                      onPressed: () => _handleDislike(user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DatingColors.errorRed,
                        foregroundColor: Colors.white,
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

  Widget _buildEnhancedPagination(int totalPages) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Page info
          Text(
            'Page $currentPage of $totalPages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          // SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First page button
              IconButton(
                onPressed: currentPage > 1 ? () => _loadPage(1) : null,
                icon: Icon(Icons.first_page),
                style: IconButton.styleFrom(
                  backgroundColor: currentPage > 1
                      ? DatingColors.primaryGreen
                      : Colors.grey[300],
                  foregroundColor:
                      currentPage > 1 ? Colors.white : Colors.grey[600],
                ),
              ),

              // Previous button
              // IconButton(
              //   onPressed:
              //       currentPage > 1 ? () => _loadPage(currentPage - 1) : null,
              //   icon: Icon(Icons.chevron_left),
              //   style: IconButton.styleFrom(
              //     backgroundColor: currentPage > 1
              //         ? DatingColors.primaryGreen
              //         : Colors.grey[300],
              //     foregroundColor:
              //         currentPage > 1 ? Colors.white : Colors.grey[600],
              //   ),
              // ),
              // SizedBox(width: 8),

              // Scrollable page numbers (show max 5 pages)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildPageButtons(totalPages),
                  ),
                ),
              ),

              // SizedBox(width: 18),
              // Next button
              // IconButton(
              //   onPressed: currentPage < totalPages
              //       ? () => _loadPage(currentPage + 1)
              //       : null,
              //   icon: Icon(Icons.chevron_right),
              //   style: IconButton.styleFrom(
              //     backgroundColor: currentPage < totalPages
              //         ? DatingColors.primaryGreen
              //         : Colors.grey[300],
              //     foregroundColor: currentPage < totalPages
              //         ? Colors.white
              //         : Colors.grey[600],
              //   ),
              // ),

              // Last page button
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => _loadPage(totalPages)
                    : null,
                icon: Icon(Icons.last_page),
                style: IconButton.styleFrom(
                  backgroundColor: currentPage < totalPages
                      ? DatingColors.primaryGreen
                      : Colors.grey[300],
                  foregroundColor: currentPage < totalPages
                      ? Colors.white
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageButtons(int totalPages) {
    List<Widget> buttons = [];
    int start = (currentPage - 2).clamp(1, totalPages);
    int end = (currentPage + 2).clamp(1, totalPages);

    // Ensure we show at least 5 pages if available
    if (end - start < 4) {
      if (start == 1) {
        end = (start + 4).clamp(1, totalPages);
      } else if (end == totalPages) {
        start = (end - 4).clamp(1, totalPages);
      }
    }

    for (int i = start; i <= end; i++) {
      buttons.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: ElevatedButton(
            onPressed: () => _loadPage(i),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentPage == i ? DatingColors.primaryGreen : Colors.white,
              foregroundColor:
                  currentPage == i ? Colors.white : DatingColors.primaryGreen,
              side: BorderSide(color: DatingColors.primaryGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(35, 35),
            ),
            child: Text('$i', style: TextStyle(fontSize: 12)),
          ),
        ),
      );
    }

    return buttons;
  }

  void _showDebugInfo(
      int currentUsersCount, int totalBackendUsers, int totalBackendPages) {
    final usersState = ref.watch(realusersprovider);
    final allUsers = usersState.data ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Debug Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mode ID: $modeId'),
              Text('Current Page: $currentPage'),
              Text('All users from backend: ${allUsers.length}'),
              Text('Users after filtering: $currentUsersCount'),
              Text('Total Backend Users: $totalBackendUsers'),
              Text('Total Backend Pages: $totalBackendPages'),
              Text('Items per page: $itemsPerPage'),
              Divider(),
              Text('Sample User Modes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...allUsers
                  .take(3)
                  .map((user) => Text(
                      '${user.firstName}: ${user.modes?.map((m) => '${m.id}(${m.mode})').join(', ') ?? 'No modes'}'))
                  .toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAllUsersDebug() {
    final usersState = ref.watch(realusersprovider);
    final allUsers = usersState.data ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('All Users Debug (${allUsers.length} users)'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            //  controller: _scrollController,
            itemCount: allUsers.length,
            itemBuilder: (context, index) {
              final user = allUsers[index];
              final userModes =
                  user.modes?.map((m) => '${m.id}(${m.mode})').join(', ') ??
                      'No modes';
              final hasTargetMode =
                  user.modes?.any((mode) => mode.id == modeId) ?? false;

              return ListTile(
                title: Text(
                    '${user.firstName ?? 'Unknown'} ${user.lastName ?? ''}'),
                subtitle: Text('Modes: $userModes'),
                trailing: hasTargetMode
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.cancel, color: Colors.red),
                tileColor: hasTargetMode ? Colors.green[50] : Colors.red[50],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Helper method to display modes with highlighting
  String _getModesDisplayWithHighlight(List<Modes>? modes) {
    if (modes == null || modes.isEmpty) return 'None';

    return modes.map((mode) {
      String display = '${mode.id}';
      return mode.id == modeId
          ? '[$display]'
          : display; // Highlight matching mode
    }).join(', ');
  }

  // Helper method to display modes
  String _getModesDisplay(List<Modes>? modes) {
    if (modes == null || modes.isEmpty) return 'None';

    return modes.map((mode) {
      return '${mode.id} (${mode.mode ?? ''})';
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

  // void _handleLike(Data user) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Liked ${user.firstName ?? 'User'}'),
  //       backgroundColor: DatingColors.primaryGreen,
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  //   ref.read(likeanddislikeprovider.notifier).addL
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
        realuserid: user.id,
        swipedirection: "right");
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
        realuserid: user.id,
        swipedirection: "left");
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
                        // child: Cached
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
                            child:
                                const Icon(Icons.image_not_supported, size: 50),
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
                // Text(
                //   'Age: ${_calculateAge(user.dob!)}',
                //   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                // ),
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


 
}