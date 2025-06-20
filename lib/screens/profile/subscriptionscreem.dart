import 'package:admin_dating/screens/profile/bottomnavbar.dart';
import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Subscriptions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search By ID......',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.filter_alt_outlined, color: Colors.black54),
                const SizedBox(width: 8),
                const Icon(Icons.sort, color: Colors.black54),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Color(0xFFB6D430), shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Churn Rate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.39,
                      strokeWidth: 18,
                      backgroundColor: Colors.grey[300],
                      color: Color(0xFFB6D430),
                    ),
                  ),
                  const Text("39.1%", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _statBox("BFF Customer", "500", true)),
                const SizedBox(width: 12),
                Expanded(child: _statBox("Subscriptions", "126", false)),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Top 5 Subscriptions By Category", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _barWithTooltip("Boost", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
            _barWithTooltip("Premium", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
            _barWithTooltip("Premium +", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
            const SizedBox(height: 20),
            const Text("Customer Growth", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFFB6D430).withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("BFF 5536", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text("New Login 126"),
                  const Text("Subscriptions 326"),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(7, (index) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: [30, 60, 20, 90, 40, 50, 30][index].toDouble(),
                          color: Color(0xFFB6D430),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Recent Subscriptions", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _recentSubTile("Denis Dias", "Feb 24, 12:00 Pm", "assets/user1.png"),
            _recentSubTile("Riyas", "Jan 12, 12:00 Pm", "assets/user2.png"),
            _recentSubTile("Halmud Alam", "Jan 2, 12:00 Pm", "assets/user3.png"),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3,),
    );
  }

  Widget _statBox(String title, String value, bool gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient ? LinearGradient(colors: [Color(0xFFB6D430), Colors.white]) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFB6D430), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _barWithTooltip(String label, String tooltipText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              height: 20,
              width: 180,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFB6D430), Colors.white]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltipText,
              child: const Icon(Icons.info_outline, size: 18),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _recentSubTile(String name, String dateTime, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateTime),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.list_alt, color: Colors.teal),
            SizedBox(width: 8),
            Icon(Icons.edit, color: Colors.orange),
            SizedBox(width: 8),
            Icon(Icons.delete, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
