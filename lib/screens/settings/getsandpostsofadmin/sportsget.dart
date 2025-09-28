import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/moreabout/relationshipprovider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/religionProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/sportsprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SportsGetScreen extends ConsumerStatefulWidget {
  const SportsGetScreen({super.key});

  @override
  ConsumerState<SportsGetScreen> createState() => _SportsGetScreenState();
}

class _SportsGetScreenState extends ConsumerState<SportsGetScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(sportsprovider.notifier).getSports());
  }

  @override
  Widget build(BuildContext context) {
    final sportsState = ref.watch(sportsprovider);
    final dataList = sportsState.data ?? [];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [DatingColors.darkGreen, Color.fromARGB(255, 40, 38, 38)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Sports"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            ),
            const Divider(height: 1),
            Expanded(
              child: sportsState.success == false
                  ? const Center(child: CircularProgressIndicator())
                  : dataList.isEmpty
                      ? const Center(child: Text("No data found"))
                      : ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final item = dataList[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: DatingColors.darkGreen,
                                ),
                              ),
                              child: ListTile(
                                title: Text(item.sportsTitle ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Edit button
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Color.fromARGB(255, 30, 121, 33)),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/sportspost',
                                          arguments: {
                                            'id': item.id,
                                            'sports_title': item.sportsTitle,
                                          },
                                        );
                                      },
                                    ),
                                    // Delete button - SINGLE DELETE BUTTON ONLY
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Confirm Delete"),
                                              content: const Text("Are you sure you want to delete this sport?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          // Use the correct provider for sports deletion
                                          // Replace this with the actual sports delete method:
                                          await ref.read(sportsprovider.notifier).deletesports(item.id);
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Sport deleted successfully")),
                                          );
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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [DatingColors.darkGreen, Color.fromARGB(255, 80, 78, 78)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/sportspost');
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}