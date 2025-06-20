import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA5C63B),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notifications",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Icon(Icons.close, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: ListView(
                children: [
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tabLabel("Report"),
                      tabLabel("Blocked"),
                      tabLabel("Overall"),
                      tabLabel("Mark All As Read", isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  sectionHeader("TODAY"),
                  notificationTile("Johndoe Reported", "Profile Anna23", "1 Hour Ago", "VIEW PROFILE", "assets/user1.png"),
                  notificationTile("Profile Mike97", "Was Flagged", "1 Hour Ago", "USER BEHAVIOR", "assets/user2.png", bgColor: Colors.redAccent.withOpacity(0.1), labelColor: Colors.red),
                  notificationTile("404 Error", "", "1 Hour Ago", "System", "assets/user3.png", bgColor: Colors.green.withOpacity(0.1), labelColor: Colors.green),

                  const SizedBox(height: 20),
                  sectionHeader("YESTERDAY"),
                  notificationTile("Amanda Reported", "Profile Fakeaccount", "1 Hour Ago", "Report", "assets/user4.png", bgColor: Colors.red.withOpacity(0.1), labelColor: Colors.red),
                  notificationTile("Bob Reported", "Zoey's Message", "6 Hour Ago", "Message Flagged", "assets/user5.png", bgColor: Colors.indigo.withOpacity(0.1), labelColor: Colors.indigo),
                  notificationTile("Andrew Upgraded", "To Premium", "6 Hour Ago", "Payment", "assets/user6.png", bgColor: Colors.green.withOpacity(0.1), labelColor: Colors.green),
                  notificationTile("Andrew Upgraded", "To Premium", "6 Hour Ago", "Payment", "assets/user7.png", bgColor: Colors.green.withOpacity(0.1), labelColor: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabLabel(String title, {bool isSmall = false}) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: isSmall ? 12 : 14,
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget notificationTile(String title, String subtitle, String time,
      String label, String imagePath,
      {Color bgColor = const Color(0xFFF5F5F5),
      Color labelColor = const Color(0xFFA5C63B)}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14),
                  ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: labelColor),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
