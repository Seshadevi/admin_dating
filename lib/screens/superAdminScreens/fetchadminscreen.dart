import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_get_provider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/superAdminScreens/createadminscreen.dart';
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
    // Fetch admins when screen opens
    Future.microtask(() {
      ref.read(adminGetsProvider.notifier).getAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminsState = ref.watch(adminGetsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        title: const Text(
          "Admins",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccountScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: adminsState.data == null || adminsState.data!.isEmpty
          ? const Center(child: Text("No admins found"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: adminsState.data!.length,
              itemBuilder: (context, index) {
                final admin = adminsState.data![index];

                String? imageUrl;
                if (admin.profilePics != null &&
                    admin.profilePics!.isNotEmpty &&
                    admin.profilePics![0] != null) {
                  imageUrl = admin.profilePics![0].toString();
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: DatingColors.darkGreen, width: 1),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl)
                              : null,
                          backgroundColor: DatingColors.darkGreen,
                          child: (imageUrl == null || imageUrl.isEmpty)
                              ? Text(
                                  (admin.firstName?.isNotEmpty ?? false)
                                      ? admin.firstName![0].toUpperCase()
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
                                "${admin.firstName ?? ''} ".trim().isNotEmpty
                                    ? "${admin.firstName ?? ''} "
                                    : "No Name",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   admin.email ?? "No Email",
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              // if (admin.role != null) ...[
                              //   const SizedBox(height: 2),
                              //   // Text(
                              //   //   "Role: ${admin.role}",
                              //   //   style: const TextStyle(
                              //   //     fontSize: 14,
                              //   //     color: Colors.black54,
                              //   //   ),
                              //   // ),
                              // ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // Reload Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: DatingColors.darkGreen,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: () {
          ref.read(adminGetsProvider.notifier).getAdmins(); // reload API
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
    ));
  }
}