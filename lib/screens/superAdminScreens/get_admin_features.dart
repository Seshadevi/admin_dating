import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_feature_provider.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_get_provider.dart';
import 'package:admin_dating/provider/superAdminProviders/roles_provider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/superAdminScreens/add_roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetAdminFeatures extends ConsumerStatefulWidget {
  const GetAdminFeatures({super.key});

  @override
  ConsumerState<GetAdminFeatures> createState() => _GetAdminFeaturesState();
}

class _GetAdminFeaturesState extends ConsumerState<GetAdminFeatures> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminFeatureProvider.notifier).getAdminFeatures();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminsState = ref.watch(adminFeatureProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        title: const Text(
          "Admin Features",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 32),
            onPressed: () {
              Navigator.pushNamed(
               context,'/addadminfeatues',
              
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
                            admin.featureName ?? "No Role Name",
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
                          Navigator.pushNamed(
                            context,
                            '/addroles',
                            arguments: {
                              'id': admin.id,
                              'roleName': admin.featureName,
                            },
                          );
                        },
                      ),


                        // Delete icon
                       IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Role"),
                                content: Text(
                                  "Are you sure you want to delete the role: ${admin.featureName ?? ''}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final success =
                                  await ref.read(rolesProvider.notifier).deleteRole(admin.id);

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Deleted role: ${admin.featureName ?? ''}",style: TextStyle(color: Colors.white),),
                                    backgroundColor: DatingColors.darkGreen,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to delete role"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
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
          ref.read(adminFeatureProvider.notifier).getAdminFeatures();
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
