// admins_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/dating_colors.dart';
import '../../models/superAdminModels/roles_get_model.dart';
import '../../provider/superAdminProviders/admin_get_provider.dart';
import '../../provider/superAdminProviders/roles_provider.dart';
import '../../screens/bottomnavbar/bottomnavbar.dart';
import '../../screens/superAdminScreens/get_roles.dart';

class AdminsScreen extends ConsumerStatefulWidget {
  const AdminsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminsScreen> createState() => _AdminsScreenState();
}

class _AdminsScreenState extends ConsumerState<AdminsScreen> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      ref.read(adminGetsProvider.notifier).getAdmins(),
      ref.read(rolesProvider.notifier).getroles(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final admins = ref.watch(adminGetsProvider);
    final rolesState = ref.watch(rolesProvider);
    final roles = rolesState.data ?? [];

    String roleName(int? roleId) {
      if (roleId == null) return "No Role";
      final role = roles.firstWhere(
            (r) => r.id == roleId,
        orElse: () => Data(roleName: "Unknown Role"),
      );
      return role.roleName ?? "Unknown Role";
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        title: Text(
          "Admins",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          Tooltip(
            message: "Add New Manager",
            child: IconButton(
              icon: Icon(Icons.person_add_alt_1, size: 28, color: theme.colorScheme.onPrimary),
              onPressed: () {
                Navigator.pushNamed(context, '/createadmin').then((_) {
                  ref.read(adminGetsProvider.notifier).getAdmins();
                });
              },
            ),
          ),
          Tooltip(
            message: "Manage Roles",
            child: IconButton(
              icon: Icon(Icons.badge_outlined, size: 28, color: theme.colorScheme.onPrimary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GetRoles()),
                );
              },
            ),
          ),
          const SizedBox(width: 12), // Spacing at the end for visual comfort
        ],
      ),

      body: admins.isEmpty
          ? Center(
        child: Text(
          "No admin found",
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: admins.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final admin = admins[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(admin.username ?? "Admin Details"),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (admin.profilePic != null && admin.profilePic!.isNotEmpty)
                              Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    admin.profilePic!.startsWith("http")
                                        ? admin.profilePic!
                                        : "http://97.74.93.26:6100/${admin.profilePic!}",
                                  ),
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: DatingColors.darkGreen,
                                child: Text(
                                  admin.username != null && admin.username!.isNotEmpty
                                      ? admin.username![0].toUpperCase()
                                      : "?",
                                  style: const TextStyle(fontSize: 40, color: Colors.white),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Text("Username: ${admin.username ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Email: ${admin.email ?? 'N/A'}"),
                            const SizedBox(height: 8),
                            Text("Role: ${roleName(admin.roleId)}"),
                            const SizedBox(height: 8),
                            Text("Assigned Pages:", style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (admin.pages != null && admin.pages.isNotEmpty)
                              ...admin.pages.map((page) => Text("• ${page.pages}")).toList()
                            else
                              const Text("None"),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
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
                          child: (admin.username?.isNotEmpty ?? false)
                              ? Text(
                            admin.username![0].toUpperCase(),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          )
                              : const Icon(Icons.person, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                admin.username ?? "No Name",
                                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                admin.email ?? "No Email",
                                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                              ),
                              Text(
                                roleName(admin.roleId),
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
                                'pages': admin.pages.map((e) => e.id).toSet(),
                                'edit': "edit",
                              },
                            ).then((_) {
                              ref.read(adminGetsProvider.notifier).getAdmins();
                            });
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
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete", style: TextStyle(color: colorScheme.error))),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ref.read(adminGetsProvider.notifier).deleteAdmin(admin.id!, context: context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DatingColors.darkGreen,
        child: Icon(Icons.refresh, color: colorScheme.onPrimary),
        onPressed: () => ref.read(adminGetsProvider.notifier).getAdmins(),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
