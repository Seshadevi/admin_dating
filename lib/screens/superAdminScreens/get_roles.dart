import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_get_provider.dart';
import 'package:admin_dating/provider/superAdminProviders/roles_provider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/superAdminScreens/add_roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRoles extends ConsumerStatefulWidget {
  const GetRoles({super.key});

  @override
  ConsumerState<GetRoles> createState() => _GetRolesState();
}

class _GetRolesState extends ConsumerState<GetRoles> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(rolesProvider.notifier).getroles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminsState = ref.watch(rolesProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        title: const Text(
          "Roles",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RolesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: adminsState.data == null || adminsState.data!.isEmpty
          ? const Center(child: Text("No roles found"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: adminsState.data!.length,
              itemBuilder: (context, index) {
                final admin = adminsState.data![index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: DatingColors.darkGreen, width: 1),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Row(
                      children: [
                        // Role name
                        Expanded(
                          child: Text(
                            admin.roleName ?? "No Role Name",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Edit icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // TODO: Implement edit role
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Edit role: ${admin.roleName ?? ''}")),
                            );
                          },
                        ),

                        // Delete icon
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // TODO: Implement delete role
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Deleted role: ${admin.roleName ?? ''}")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DatingColors.darkGreen,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: () {
          ref.read(rolesProvider.notifier).getroles();
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
