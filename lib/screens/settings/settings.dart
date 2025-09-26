import 'package:admin_dating/provider/logout_notifier.dart';
import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:admin_dating/theme_provider.dart'; // Import your theme provider
import 'package:flutter/material.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/dating_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool pushNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  void _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pushNotifications = prefs.getBool('pushNotifications') ?? true;
    });
  }

  void _saveNotificationSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user data from loginProvider
    final userModel = ref.watch(loginProvider);
    final isDarkMode = ref.watch(themeProvider); // Watch theme state

    // Extract user name - handle different possible field names
    String userName = 'Guest User'; // Default fallback

    if (userModel.data != null && userModel.data!.isNotEmpty) {
      final user = userModel.data!.first.user;
      if (user != null) {
        // Try to get username (fix the repetitive field access)
        userName = user.username ??
            'User';
      }
    }

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1E1E1E)  // Dark background
          : const Color(0xFFA5C63B),  // Light green background
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: ListView(
                children: [
                  // Profile Section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        ),
                        // You can replace with actual profile image:
                        // backgroundImage: AssetImage('assets/images/settingpage.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Admin User',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "Account Settings",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  buildTile("Edit profile",
                    icon: Icons.edit_outlined,
                    context: context,
                  ),
                  buildTile("Change password",
                    icon: Icons.lock_outline,
                    context: context,
                  ),
                  buildTile("Signin process data changes",
                    icon: Icons.admin_panel_settings_outlined,
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/postadminscreen');
                    },
                  ),
                  buildTile("Add Report Categories",
                    icon: Icons.add_card_outlined,
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/get_report_categories');
                    },
                  ),

                  // Push Notifications Switch
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: SwitchListTile(
                      value: pushNotifications,
                      onChanged: (val) {
                        setState(() => pushNotifications = val);
                        _saveNotificationSettings(val);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        "Push notifications",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      secondary: Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  // Dark Mode Switch
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: SwitchListTile(
                      value: isDarkMode,
                      onChanged: (val) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        "Dark mode",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      secondary: Icon(
                        isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "More",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  buildTile("User management",
                    icon: Icons.people_outline,
                    context: context,
                  ),
                  buildTile("Privacy policy",
                    icon: Icons.privacy_tip_outlined,
                    context: context,
                  ),
                  buildTile("Notifications",
                    icon: Icons.notifications_none_outlined,
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, 'notificationscreen');
                    },
                  ),
                  buildTile("Analytics",
                    icon: Icons.analytics_outlined,
                    context: context,
                  ),
                  buildTile("Terms And Conditions",
                    icon: Icons.article_outlined,
                    context: context,
                  ),

                  const SizedBox(height: 20),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _confirmLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Log out?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'You will need to sign in again.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Log out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      await ref.read(logoutProvider.notifier).logout(context);
    }
  }

  Widget buildTile(String title, {
    required IconData icon,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        onTap: onTap,
      ),
    );
  }
}