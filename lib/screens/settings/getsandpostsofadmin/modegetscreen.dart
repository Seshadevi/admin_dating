import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/lookingProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/modeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModeGetScreen extends ConsumerStatefulWidget {
  const ModeGetScreen({super.key});

  @override
  ConsumerState<ModeGetScreen> createState() =>
      _ModeGetScreenState();
}

class _ModeGetScreenState extends ConsumerState<ModeGetScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(modesProvider.notifier).getModes());
  }

  @override
  Widget build(BuildContext context) {
    final modesState = ref.watch(modesProvider);
    final dataList = modesState.data ?? [];

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
        title: const Text("Modes"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              // child: Row(
              //   children: [
              //     Text(
              //       "Looking For List",
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
            ),
            const Divider(height: 1),
            Expanded(
              child: modesState.success == false
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
                                title: Text(item.value ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Color.fromARGB(255, 30, 121, 33)),
                                      
                                        onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/modespost',
                                          arguments: {
                                            'id': item.id,
                                            'modes': item.value,
                                          },
                                        );
                                      },
                              
                                      
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: ()async {
                                        // TODO: Handle delete 
                                        // await ref.read(modesProvider.notifier).deleteMode(item.id);
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     const SnackBar(content: Text("Deleted successfully")),
                                        //   );
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
                    Navigator.pushNamed(context, '/modespost');
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
