import 'package:admin_dating/provider/logout_notifier.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:admin_dating/screens/profile/notifications_screen.dart'; // make sure this exists

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
                  ElevatedButton(
                    onPressed: () {
                      _confirmLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 5),
    );
  }
   Future<void> _confirmLogout() async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Log out?'),
      content: const Text('You will need to sign in again.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log out')),
      ],
    ),
  );

  if (ok == true) {
    await ref.read(logoutProvider.notifier).logout(context);
  }
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
