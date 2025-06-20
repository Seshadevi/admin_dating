import 'package:admin_dating/screens/profile/bottomnavbar.dart';
import 'package:flutter/material.dart';
// import '../widgets/custom_bottom_navbar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 2;

  Widget _buildReportItem() {
    return Column(
      children: List.generate(6, (index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(''), // Dummy image
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("User Id: BK-W210D6", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("Username (Editor)", style: TextStyle(color: Colors.green)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: const [
                    Chip(label: Text("Type: Book"), backgroundColor: Colors.orangeAccent),
                    Icon(Icons.picture_as_pdf, color: Colors.blue),
                    Icon(Icons.share, color: Colors.red),
                  ],
                )
              ],
            ),
            trailing: const Text("16 Feb\n11 AM", textAlign: TextAlign.center),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Report"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.green[100],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(child: Text("Search", style: TextStyle(color: Colors.grey))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white),
                  )
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
                      backgroundColor: index == 0 ? Colors.green : Colors.grey[300],
                      child: Text("${index + 1}",
                          style: const TextStyle(fontSize: 12, color: Colors.white)),
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
