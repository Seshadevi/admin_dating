import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';

import 'cat_report.dart';
import 'cat_report_display.dart'; // import your colors

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 2;

  Widget _buildReportItem() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: List.generate(6, (index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          color: colorScheme.surface,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(''), // Dummy image placeholder
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Id: BK-W210D6",
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                Text(
                  "Username (Editor)",
                  style: theme.textTheme.bodyMedium?.copyWith(color: DatingColors.primaryGreen),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    Chip(label: const Text("Type: Book"), backgroundColor: Colors.orangeAccent.shade100),
                    Icon(Icons.picture_as_pdf, color: Colors.blue.shade700),
                    Icon(Icons.share, color: Colors.red.shade700),
                  ],
                ),
              ],
            ),
            trailing: Text(
              "16 Feb\n11 AM",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
            ),
            onTap: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 200, 0, 0),
                items: const [
                  PopupMenuItem(child: Text('View Details')),
                  PopupMenuItem(child: Text('Download Report')),
                  PopupMenuItem(child: Text('Share')),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Report"),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        titleTextStyle: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: DatingColors.primaryGreen,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportCategoriesScreen()),
              );
            },
            tooltip: 'Add Report Category',
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            child: Text("Search",
                                style: theme.textTheme.bodyMedium?.copyWith(color: DatingColors.secondaryText)),
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
            _buildReportItem(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0 ? DatingColors.primaryGreen : Colors.grey[300],
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
