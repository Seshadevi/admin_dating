// import 'package:admin_dating/constants/dating_colors.dart';
// import 'package:admin_dating/provider/superAdminProviders/admin_get_provider.dart';
// import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
// import 'package:admin_dating/screens/superAdminScreens/add_roles.dart';
// import 'package:admin_dating/screens/superAdminScreens/createadminscreen.dart';
// import 'package:admin_dating/screens/superAdminScreens/get_roles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class AdminsScreen extends ConsumerStatefulWidget {
//   const AdminsScreen({super.key});
//
//   @override
//   ConsumerState<AdminsScreen> createState() => _AdminsScreenState();
// }
//
// class _AdminsScreenState extends ConsumerState<AdminsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(adminGetsProvider.notifier).getAdmins();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // CHANGE: Expect a List<AdminGetModel>
//     final adminList = ref.watch(adminGetsProvider);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: DatingColors.darkGreen,
//         elevation: 0,
//         title: const Text(
//           "Admins",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(
//                 context,
//                 '/createadmin',
//               );
//               ref.read(adminGetsProvider.notifier).getAdmins();
//             },
//             child: const Text(
//               "Create Admin",
//               style:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.add_circle_outline, size: 32),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const GetRoles(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: adminList == null || adminList.isEmpty
//           ? const Center(child: Text("No admin found"))
//           : Padding(
//               padding: const EdgeInsets.all(12),
//               child: ListView.separated(
//                 itemCount: adminList.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final admin = adminList[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: BorderSide(color: DatingColors.darkGreen, width: 1),
//                     ),
//                     elevation: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundImage: (admin.profilePic != null &&
//                                     admin.profilePic!.isNotEmpty)
//                                 ? NetworkImage(
//                                     admin.profilePic!.startsWith("http")
//                                         ? admin.profilePic!
//                                         : "http://97.74.93.26:6100/${admin.profilePic!}",
//                                   )
//                                 : null,
//                             backgroundColor: DatingColors.darkGreen,
//                             child: (admin.profilePic == null ||
//                                     admin.profilePic!.isEmpty)
//                                 ? Text(
//                                     (admin.username?.isNotEmpty ?? false)
//                                         ? admin.username![0].toUpperCase()
//                                         : "?",
//                                     style: const TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                           const SizedBox(width: 14),
//
//                           // ====== Info Section ======
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(admin.username ?? "No Name",
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                                 const SizedBox(height: 4),
//                                 Text(admin.email ?? "No Email",
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey)),
//                                 // Text(admin.password ?? "No Password",
//                                 //     style: const TextStyle(fontSize: 14, color: Colors.grey)),
//                                 Text(admin.role?.roleName ?? "No Role",
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.black54)),
//                               ],
//                             ),
//                           ),
//
//                           // ====== ACTION ICONS ======
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 '/createadmin',
//                                 arguments: {
//                                   'id': admin.id,
//                                   'username': admin.username,
//                                   'email': admin.email,
//                                   'password': admin.password,
//                                   'roleId': admin.roleId,
//                                   'profilePic': admin.profilePic,
//                                 },
//                               );
//                             },
//                           ),
//
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () async {
//                               final confirm = await showDialog<bool>(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: const Text("Delete Admin"),
//                                   content: const Text(
//                                       "Are you sure you want to delete this admin?"),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, false),
//                                       child: const Text("Cancel"),
//                                     ),
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, true),
//                                       child: const Text(
//                                         "Delete",
//                                         style: TextStyle(color: Colors.red),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//
//                               if (confirm == true) {
//                                 ref
//                                     .read(adminGetsProvider.notifier)
//                                     .deleteAdmin(admin.id!, context: context);
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: DatingColors.darkGreen,
//         child: const Icon(Icons.refresh, color: Colors.white),
//         onPressed: () {
//           ref.read(adminGetsProvider.notifier).getAdmins();
//         },
//       ),
//       bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
//     );
//   }
// }



import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_get_provider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/superAdminScreens/get_roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminsScreen extends ConsumerStatefulWidget {
  const AdminsScreen({super.key});

  @override
  ConsumerState<AdminsScreen> createState() => _AdminsScreenState();
}

class _AdminsScreenState extends ConsumerState<AdminsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminGetsProvider.notifier).getAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final adminList = ref.watch(adminGetsProvider);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        title: Text(
          "Admins",
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createadmin');
              ref.read(adminGetsProvider.notifier).getAdmins();
            },
            child: Text(
              "Create Admin",
              style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 32, color: colorScheme.onPrimary),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GetRoles()));
            },
          ),
        ],
      ),
      body: (adminList == null || adminList.isEmpty)
          ? Center(
        child: Text(
          "No admin found",
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: adminList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final admin = adminList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: DatingColors.darkGreen, width: 1),
              ),
              elevation: 3,
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: (admin.profilePic != null && admin.profilePic!.isNotEmpty)
                          ? NetworkImage(
                        admin.profilePic!.startsWith("http")
                            ? admin.profilePic!
                            : "http://97.74.93.26:6100/${admin.profilePic!}",
                      )
                          : null,
                      backgroundColor: DatingColors.darkGreen,
                      child: (admin.profilePic == null || admin.profilePic!.isEmpty)
                          ? Text(
                        (admin.username?.isNotEmpty ?? false)
                            ? admin.username![0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            admin.username ?? "No Name",
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            admin.email ?? "No Email",
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                          ),
                          Text(
                            admin.role?.roleName ?? "No Role",
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: colorScheme.primary),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/createadmin',
                          arguments: {
                            'id': admin.id,
                            'username': admin.username,
                            'email': admin.email,
                            'password': admin.password,
                            'roleId': admin.roleId,
                            'profilePic': admin.profilePic,
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Admin", style: theme.textTheme.titleMedium),
                            content: Text("Are you sure you want to delete this admin?", style: theme.textTheme.bodyMedium),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Delete", style: TextStyle(color: colorScheme.error)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          ref.read(adminGetsProvider.notifier).deleteAdmin(admin.id!, context: context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DatingColors.darkGreen,
        child: Icon(Icons.refresh, color: colorScheme.onPrimary),
        onPressed: () {
          ref.read(adminGetsProvider.notifier).getAdmins();
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
