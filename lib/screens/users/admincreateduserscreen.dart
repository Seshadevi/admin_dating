import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/admincreatedusersprovider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dating/models/users/admincreatedusersmodes.dart';
// import 'package:admin_dating/provider/admincreatedusersprovider.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(admincreatedusersprovider.notifier).getAdmincreatedusers(page: 1);
    });

    // 🔥 Add listener for infinite scroll
  _scrollController.addListener(() {
  final users = ref.read(admincreatedusersprovider).data ?? [];
  
  // Load next page when last 5 items are visible
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200 && // ~near bottom
      users.isNotEmpty) {
    ref.read(admincreatedusersprovider.notifier).getNextPage();
  }
});

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(admincreatedusersprovider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: DatingColors.surfaceGrey,
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: DatingColors.white,
              fontSize: 26),
        ),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Add user functionality
              // _showAddUserDialog(context);
              Navigator.pushNamed(
                context,
                '/addprofilescreen',
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: DatingColors.white,
              size: 48,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: DatingColors.darkGreen,
              ),
            )
          : usersState.data == null || usersState.data!.isEmpty
              ? _buildEmptyState()
              : _buildUsersList(usersState.data!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(admincreatedusersprovider.notifier).getAdmincreatedusers();
        },
        backgroundColor: DatingColors.darkGreen,
        child: const Icon(Icons.refresh, color: DatingColors.white),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Users will appear here once available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildUsersList(List<Data> users) {
  final isLoadingNextPage = ref.read(admincreatedusersprovider.notifier).isLoadingNextPage;

  return RefreshIndicator(
    onRefresh: () async {
      await ref.read(admincreatedusersprovider.notifier).refreshUsers();
    },
    child: ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: users.length + (isLoadingNextPage ? 1 : 0), // add extra item for loader
      itemBuilder: (context, index) {
        if (index >= users.length) {
          // Bottom loader for page 2+
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final user = users[index];
        return _buildUserCard(user);
      },
    ),
  );
}




  Widget _buildUserCard(Data user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: DatingColors.darkGreen, // 👈 border color
          width: 1, // 👈 border width
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
                  _buildActionButtons(user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(Data user) {
    String baseUrl = "http://97.74.93.26:6100";
    String? imageUrl = user.profilePics?.isNotEmpty == true
        ? "$baseUrl${user.profilePics!.first.url}" // 👈 prepend base URL
        : null;
    print('images.......$imageUrl');

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

  Widget _buildDefaultAvatar(Data user) {
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

  Widget _buildUserName(Data user) {
    String fullName = '';
    if (user.firstName?.isNotEmpty == true) {
      fullName = user.firstName!;
      if (user.lastName?.isNotEmpty == true) {
        fullName += ' ${user.lastName!}';
      }
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            fullName.isNotEmpty ? fullName : 'Unknown User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        // if (user.showOnProfile == true)
        //   Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //     decoration: BoxDecoration(
        //       color: Colors.green.withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(12),
        //       border: Border.all(color: Colors.green.withOpacity(0.3)),
        //     ),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Icon(
        //           Icons.verified,
        //           size: 14,
        //           color: Colors.green[600],
        //         ),
        //         const SizedBox(width: 4),
        //         Text(
        //           'Verified',
        //           style: TextStyle(
        //             fontSize: 12,
        //             color: Colors.green[600],
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildUserDetails(Data user) {
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
        if (user.mobile?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                user.mobile!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
        if (user.gender?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                user.gender!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              if (user.height != null) ...[
                Text(
                  ' • ${user.height}cm',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(Data user) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.group,
          color: Colors.blue,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/realusersscreen',
              arguments: {
                'accessToken': user.accessToken,
                'userId': user.id,
                'modeId': user.modes!.first.id
              },
            );
          },
          // => _showUserDetails(user),
          tooltip: 'View Details',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.message,
          color: DatingColors.darkGreen,

          onPressed: () {
            Navigator.pushNamed(
              context,
              '/matchesscreen',
              arguments: {
                'accessToken': user.accessToken,
                'userId': user.id,
              },
            );
          },
          // => _editUser(user),
          tooltip: 'message User',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.favorite_border,
          color: Colors.pinkAccent,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/likesdislikesscreen',
              arguments: {
                'accessToken': user.accessToken,
                'userId': user.id,
                'userRole': user.role,
              },
            );
          },
          tooltip: 'Contact',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.edit_outlined,
          color: Colors.grey,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/editprofilesscreen',
              arguments: {
                'accestoken': user.accessToken,
                'userId': user.id,
                'modeId': (user.modes != null && user.modes!.isNotEmpty)
                    ? user.modes!.first.mode
                    : null,

                'userRole': user.role,
                'firstName': user.firstName,
                'lastName': user.lastName,
                'dateOfBirth': user.dob,
                'email': user.email,
                'phoneNo': user.mobile,
                'gender': user.gender,
                'showOnProfile':user.showOnProfile,
                'height': user.height,
                'genderWant': user.genderIdentities
                        ?.where((e) => e.identity != null)
                        .map((e) => e.identity!)
                        .toList() ??
                    [],
                'causes': user.causesAndCommunities
                        ?.where((e) => e.causesAndCommunities != null)
                        .map((e) => e.causesAndCommunities!)
                        .toList() ??
                    [],
                'causesId': user.causesAndCommunities
                        ?.where((e) => e.id != null)
                        .map((e) => e.id!)
                        .toList() ??
                    [],
                'interests': user.interests
                        ?.map((e) => e.interests)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'interestsId': user.interests
                        ?.where((e) => e.id != null)
                        .map((e) => e.id)
                        // .whereType<String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],

                'qualities': user.qualities
                        ?.map((e) => e.name)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'qualitiesId': user.qualities
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'lookingFor': user.lookingFor
                        ?.map((e) => e.value)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'lookingForId': user.lookingFor
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],

                // ✅ Fixed versions
                'industry': user.industries
                        ?.map((e) => e.industrie)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'industryId': user.industries
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'experience': user.experiences
                        ?.map((e) => e.experience)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'experienceId': user.experiences
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'relationship': user.relationships
                        ?.map((e) => e.relation)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'relationshipId': user.relationships
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],

                'starSign': user.starSign ?? '',
                'educationLevel': user.educationLevel ?? '',
                'newToArea': user.newToArea ?? "",
                'hometown': user.hometown ?? '',
                'defaultMessages': user.defaultMessages
                        ?.map((e) => e.message)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'defaultMessagesId': user.defaultMessages
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],

                'haveKids': user.haveKids ?? '',
                // 'religion': user.religions
                //   ?.map((e) => e.religion)
                //   .whereType<String>()
                //   .join(', ')  // join list into one string
                //   ?? '',
                'kids': user.kids
                        ?.map((e) => e.kids)
                        .whereType<String>()
                        .join(', ') // join list into one string
                    ??
                    '',
                'drinking': user.drinking
                        ?.map((e) => e.preference)
                        .whereType<String>()
                        .join(', ') // join list into one string
                    ??
                    '',
                 'religion': user.religions
                        ?.map((e) => e.religion)
                        .whereType<String>()
                        .join(', ') // join list into one string
                    ??
                    '',   

                // 'pronoun': user.pronouns,
                'prompts': user.prompts?.map((p) => p.toJson()).toList(),
                'profilePics': user.profilePics,
                'politics': user.politics,
                'languages': user.spokenLanguages
                        ?.map((e) => e.name)
                        .whereType<
                            String>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'languagesId': user.spokenLanguages
                        ?.map((e) => e.id)
                        .whereType<
                            int>() // removes nulls and makes it List<String>
                        .toList() ??
                    [],
                'pronoun':user.pronouns,
                'latitude':user.location!.latitude,
                'longitude':user.location!.longitude,
                'city':user.location!.name
                
                   
              },
            );
          },
          tooltip: 'Add to Favorites',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.delete,
          color: Colors.red,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Delete"),
                  content: const Text(
                      "Are you sure you want to delete this Botuser"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // close dialog
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        print('userId.......${user.id}');
                        // your delete logic here
                        await ref
                            .read(admincreatedusersprovider.notifier)
                            .deletefakeuser(fakeuserId: user.id);

                        // Navigator.of(context)
                        //     .pop(); // close dialog after action
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          tooltip: 'delete',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            size: 19,
            color: color,
          ),
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        // content: const Text(''),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/addprofilescreen',
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Data user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => UserDetailsSheet(
          user: user,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _editUser(Data user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit user: ${user.firstName ?? "Unknown"}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // void _contactUser(Data user) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Contacting: ${user.firstName ?? "Unknown"}'),
  //       backgroundColor: Colors.orange,
  //     ),
  //   );
  // }

  void _favoriteUser(Data user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${user.firstName ?? "Unknown"} to favorites'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// User Details Bottom Sheet
class UserDetailsSheet extends StatelessWidget {
  final Data user;
  final ScrollController scrollController;

  const UserDetailsSheet({
    Key? key,
    required this.user,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Profile Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.deepPurple.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: user.profilePics?.isNotEmpty == true &&
                                  user.profilePics!.first.url?.isNotEmpty ==
                                      true
                              ? Image.network(
                                  user.profilePics!.first.url!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar();
                                  },
                                )
                              : _buildDefaultAvatar(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (user.email?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.email!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Details Sections
                _buildDetailSection('Personal Information', [
                  if (user.gender?.isNotEmpty == true)
                    _buildDetailItem('Gender', user.gender!),
                  if (user.dob?.isNotEmpty == true)
                    _buildDetailItem('Date of Birth', user.dob!),
                  if (user.height != null)
                    _buildDetailItem('Height', '${user.height} cm'),
                  if (user.mobile?.isNotEmpty == true)
                    _buildDetailItem('Mobile', user.mobile!),
                ]),

                if (user.interests?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection(
                      'Interests',
                      user.interests!
                          .map((interest) =>
                              _buildDetailItem('', interest.interests ?? ''))
                          .toList()),
                ],

                if (user.qualities?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection(
                      'Qualities',
                      user.qualities!
                          .map((quality) =>
                              _buildDetailItem('', quality.name ?? ''))
                          .toList()),
                ],

                const SizedBox(height: 100), // Extra space for safe area
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
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
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: label.isEmpty ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
