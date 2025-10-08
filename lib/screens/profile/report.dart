import 'package:admin_dating/models/users/get_reports_model.dart';
import 'package:admin_dating/provider/users/get_reports_providers.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/profile/cat_report_display.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cat_report.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(getReportsProviders.notifier).getereports());
  }

  int _selectedIndex = 2;

    @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getReportsProviders);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Report"),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        titleTextStyle: theme.textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
       
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔍 Search + Filter Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: DatingColors.lightGreen.withOpacity(0.4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: DatingColors.secondaryText),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search reports...",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DatingColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 📋 Dynamic Reports List
            state == null
            ? const Center(child: CircularProgressIndicator())
            : _buildReportList(state),

            const SizedBox(height: 12),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }



    Widget _buildReportList(GetReportModel? reportData) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (reportData == null || reportData.reports == null || reportData.reports!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No reports found."),
        ),
      );
    }
   
     // 🔍 Filter reports
  final filteredReports = reportData.reports!.where((report) {
    final userId = (report.userId?.toString() ?? "").toLowerCase();
    final desc = (report.description ?? "").toLowerCase();
    final reporter = (report.reporter?.firstName ?? "").toLowerCase();

    return userId.contains(_searchQuery) ||
           desc.contains(_searchQuery) ||
           reporter.contains(_searchQuery);
  }).toList();

  if (filteredReports.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text("No matching reports."),
      ),
    );
  }

    return Column(
      children: filteredReports.map((report) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          color: colorScheme.surface,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: DatingColors.primaryGreen.withOpacity(0.2),
              child: Icon(Icons.report, color: DatingColors.primaryGreen),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User ID: ${report.userId ?? '-'}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Description: ${report.description ?? 'No description'}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: DatingColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Reported By: ${report.reporter?.firstName ?? 'Unknown'}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DatingColors.primaryGreen,
                  ),
                ),
              ],
            ),
            
          ),
        );
      }).toList(),
    );
  }
}
