import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/lookingProvider.dart';
import 'package:admin_dating/provider/users/report_categories_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportCategories extends ConsumerStatefulWidget {
  const ReportCategories({super.key});

  @override
  ConsumerState<ReportCategories> createState() =>
      _ReportCategoriesState();
}

class _ReportCategoriesState extends ConsumerState<ReportCategories> {
   final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(reportCategoriesProviders.notifier).getReportCategries(page: _currentPage));
    _scrollController.addListener(() {
      final state = ref.read(reportCategoriesProviders);

      if (state.pagination == null) return;

      final totalPages = state.pagination?.totalPages ?? 1;

      // 👇 Trigger when only 5 items remain visible
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          _currentPage < totalPages) {
        _currentPage++;
        ref
            .read(reportCategoriesProviders.notifier)
            .getReportCategries(page: _currentPage, append: true);
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
    final state = ref.watch(reportCategoriesProviders);
    final dataList = state.data?? [];

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
        title: const Text("Categories"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            
           // const Divider(height: 1),
            Expanded(
              child: state.success == false && dataList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : dataList.isEmpty
                      ? const Center(child: Text("No data found"))
                      : ListView.builder(
                        controller: _scrollController,
                          itemCount: dataList.length + 1,
                          itemBuilder: (context, index) {
                             if (index == dataList.length) {
                                final totalPages = state.pagination?.totalPages ?? 1;
                                if (_currentPage < totalPages) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }

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
                                title: Text(item.category ?? ''),
                                
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Color.fromARGB(255, 30, 121, 33)),
                                      
                                        onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/add_report_categories',
                                          arguments: {
                                            'id': item.id,
                                            'category': item.category,
                                            
                                          },
                                        );
                                      },
                              
                                      
                                    ),
                                    IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Confirm Delete"),
                                            content: const Text("Are you sure you want to delete this Category?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false), // Cancel
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () => Navigator.pop(context, true), // Confirm
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirm == true) {
                                        await ref.read(reportCategoriesProviders.notifier).deleteReportCategories(categoryId:  item.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Deleted successfully")),
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
                    Navigator.pushNamed(context, '/add_report_categories');
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
