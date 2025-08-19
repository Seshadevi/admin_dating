import 'package:flutter/material.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
// import 'package:admin_dating/screens/profile/notifications_screen.dart'; // make sure this exists

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA5C63B),
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Setting",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: ListView(
                children: [
                  // Profile Section
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage:
                            AssetImage('assets/images/settingpage.png'),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Yennefer Doe",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    "Account Settings",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  buildTile("Edit profile"),
                  buildTile("Change password"),
                  buildTile("Signin process data changes", onTap: () {
                    Navigator.pushNamed(context, '/postadminscreen');
                  }),
                  buildTile("Add a subcribtion method", icon: Icons.add),

                  SwitchListTile(
                    value: pushNotifications,
                    onChanged: (val) {
                      setState(() => pushNotifications = val);
                    },
                    activeColor: const Color(0xFFA5C63B),
                    title: const Text("Push notifications"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    value: darkMode,
                    onChanged: (val) {
                      setState(() => darkMode = val);
                    },
                    activeColor: const Color(0xFFA5C63B),
                    title: const Text("Dark mode"),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 20),
                  const Text("More", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),

                  buildTile("user management"),
                  buildTile("Privacy policy"),
                  buildTile("notification", onTap: () {
                    Navigator.pushNamed(
                      context,
                      'notificationscreen',
                    );
                  }),
                  buildTile("Analytics"),
                  buildTile("Trems And Conditions"),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 5),
    );
  }

  Widget buildTile(String title,
      {IconData icon = Icons.arrow_forward_ios, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: Icon(icon, size: 16, color: Colors.black),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
