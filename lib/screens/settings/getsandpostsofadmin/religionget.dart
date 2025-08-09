import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/drinkingProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/lookingProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/religionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReligionGetScreen extends ConsumerStatefulWidget {
  const ReligionGetScreen({super.key});

  @override
  ConsumerState<ReligionGetScreen> createState() =>
      _ReligionGetScreenState();
}

class _ReligionGetScreenState extends ConsumerState<ReligionGetScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(religionProvider.notifier).getReligions());
  }

  @override
  Widget build(BuildContext context) {
    final religionState = ref.watch(religionProvider);
    final dataList = religionState.data ?? [];

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
        title: const Text("Religions"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              
            ),
            const Divider(height: 1),
            Expanded(
              child: religionState.success == false
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
                                title: Text(item.religion ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Color.fromARGB(255, 30, 121, 33)),
                                      
                                        onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/religionpost',
                                          arguments: {
                                            'id': item.id,
                                            'religion': item.religion,
                                          },
                                        );
                                      },
                              
                                      
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async{
                                        // TODO: Handle delete action
                                        await ref.read(religionProvider.notifier).deleteReligion(item.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Deleted successfully")),
                                          );
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
                    Navigator.pushNamed(context, '/religionpost');
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
