// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../constants/dating_colors.dart';

// class _TabItem {
//   final IconData icon;
//   final String label;
//   final String route;
//   const _TabItem(this.icon, this.label, this.route);
// }

// class CustomBottomNavBar extends ConsumerStatefulWidget {
//   final int currentIndex;
//   const CustomBottomNavBar({super.key, required this.currentIndex});

//   @override
//   ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
//   List<_TabItem> _tabsForRole(String? role) {
//     final r = (role ?? '').toLowerCase();
//     if (r == 'superadmin') {
//       return const [
//         _TabItem(Icons.dashboard, 'Dashboard', 'dashboardscreen'),
//         _TabItem(Icons.admin_panel_settings, 'Admins', 'superadmincreatedadminsscreen'),
//         _TabItem(Icons.bar_chart, 'Reports', 'reportscreen'),
//         _TabItem(Icons.subscriptions, 'Subscriptions', 'subscriptionscreen'),
//         _TabItem(Icons.verified, 'Verify', 'swipesscreen'),
//         _TabItem(Icons.settings, 'Setting', 'settingscreen'),
//       ];
//     }
//     return const [
//       _TabItem(Icons.dashboard, 'Dashboard', 'dashboardscreen'),
//       _TabItem(Icons.person, 'Users', 'adminusersscreen'),
//       _TabItem(Icons.verified, 'Verify', 'swipesscreen'),
//       _TabItem(Icons.settings, 'Setting', 'settingscreen'),
//     ];
//   }

//   void _onTap(BuildContext context, List<_TabItem> tabs, int index) {
//     if (index < 0 || index >= tabs.length) return;
//     final targetRoute = tabs[index].route;
//     if (ModalRoute.of(context)?.settings.name == targetRoute) return;
//     Navigator.pushReplacementNamed(context, targetRoute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     final userModel = ref.watch(loginProvider);
//     final role = userModel.data?.first.user?.role;
//     final tabs = _tabsForRole(role);
//     final safeIndex = widget.currentIndex.clamp(0, tabs.length - 1);

//     return BottomNavigationBar(
//       currentIndex: safeIndex,
//       backgroundColor: DatingColors.darkGreen,                // Uses your primaryGreen from DatingColors
//       selectedItemColor: DatingColors.white,             // Typically white for contrast
//       unselectedItemColor: DatingColors.darkText,
//       type: BottomNavigationBarType.fixed,
//       onTap: (index) => _onTap(context, tabs, index),
//       items: [
//         for (final t in tabs)
//           BottomNavigationBarItem(
//             icon: Icon(t.icon),
//             label: t.label,
//           ),
//       ],
//       selectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
//         color: colorScheme.onPrimary,
//         fontWeight: FontWeight.w600,
//       ),
//       unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
//         color: colorScheme.onPrimary.withOpacity(0.65),
//       ),
//       showUnselectedLabels: true,
//       elevation: 8,
//     );
//   }
// }




// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../constants/dating_colors.dart';

// class _TabItem {
//   final IconData icon;
//   final String label;
//   final String route;
//   const _TabItem(this.icon, this.label, this.route);
// }

// class CustomBottomNavBar extends ConsumerStatefulWidget {
//   final int currentIndex;
//   const CustomBottomNavBar({super.key, required this.currentIndex});

//   @override
//   ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
//   // Desired global order
//   static const List<String> _desiredOrder = [
//     'dashboard',
//     'users',
//     'staff',
//     'reports',
//     'subscriptions',
//     'verify',
//     'settings',
//   ];

//   // Page-name -> Tab mapping (label can be pretty-cased for UI)
//   static const Map<String, _TabItem> _pageMap = {
//     'dashboard': _TabItem(Icons.dashboard, 'Dashboard', 'dashboardscreen'),
//     'users': _TabItem(Icons.person, 'Users', 'adminusersscreen'),
//     'staff': _TabItem(Icons.admin_panel_settings, 'Staff', 'superadmincreatedadminsscreen'),
//     'reports': _TabItem(Icons.bar_chart, 'Reports', 'reportscreen'),
//     'subscriptions': _TabItem(Icons.subscriptions, 'Subscriptions', 'subscriptionscreen'),
//     'verify': _TabItem(Icons.verified, 'Verify', 'swipesscreen'),
//     'settings': _TabItem(Icons.settings, 'Settings', 'settingscreen'),
//   };

//   List<_TabItem> _tabsFromLoginPages() {
//     final userModel = ref.watch(loginProvider);
//     final pages = userModel.data?.first.user?.pages ?? const [];

//     // Build a set of available page names (lowercased) from backend
//     final available = {
//       for (final p in pages)
//         if ((p.pages ?? '').trim().isNotEmpty) (p.pages!).toLowerCase().trim()
//     };

//     // Keep only pages that exist, and in desired order
//     final orderedKeys =
//         _desiredOrder.where((k) => available.contains(k)).toList();

//     // Map to TabItems (ignore any unknown keys safely)
//     final tabs = <_TabItem>[];
//     for (final key in orderedKeys) {
//       final t = _pageMap[key];
//       if (t != null) tabs.add(t);
//     }

//     // Fallback: if backend gave nothing or none matched, show Dashboard
//     if (tabs.isEmpty) {
//       tabs.add(_pageMap['dashboard']!);
//      // tabs.add(_pageMap['users']!);
//       tabs.add(_pageMap['settings']!);
//     }
//     return tabs;
//   }

//   void _onTap(BuildContext context, List<_TabItem> tabs, int index) {
//     if (index < 0 || index >= tabs.length) return;
//     final targetRoute = tabs[index].route;
//     if (ModalRoute.of(context)?.settings.name == targetRoute) return;
//     Navigator.pushReplacementNamed(context, targetRoute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     final tabs = _tabsFromLoginPages();
//     final safeIndex = widget.currentIndex.clamp(0, tabs.length - 1);

//     return BottomNavigationBar(
//       currentIndex: safeIndex,
//       backgroundColor: DatingColors.darkGreen,
//       selectedItemColor: DatingColors.white,
//       unselectedItemColor: DatingColors.darkText,
//       type: BottomNavigationBarType.fixed,
//       onTap: (index) => _onTap(context, tabs, index),
//       items: [
//         for (final t in tabs)
//           BottomNavigationBarItem(icon: Icon(t.icon), label: t.label),
//       ],
//       selectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
//         color: colorScheme.onPrimary,
//         fontWeight: FontWeight.w600,
//       ),
//       unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
//         color: colorScheme.onPrimary.withOpacity(0.65),
//       ),
//       showUnselectedLabels: true,
//       elevation: 8,
//     );
//   }
// }



import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/screens/profile/dashboard.dart';
import 'package:admin_dating/screens/profile/report.dart';

import 'package:admin_dating/screens/profile/verfication_screen.dart';
import 'package:admin_dating/screens/settings/settings.dart';
import 'package:admin_dating/screens/subscriptions/subscriptionscreem.dart';
import 'package:admin_dating/screens/superAdminScreens/fetchadminscreen.dart';
import 'package:admin_dating/screens/users/admincreateduserscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/dating_colors.dart';

// Tab structure
class _TabItem {
  final IconData icon;
  final String label;
  final Widget page;
  const _TabItem(this.icon, this.label, this.page);
}

class CustomBottomNavBar extends ConsumerStatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  int _selectedIndex = 0;

  // Desired global order
  static const List<String> _desiredOrder = [
    'dashboard',
    'users',
    'staff',
    'reports',
    'subscriptions',
    'verify',
    'settings',
  ];

  // Map pageName -> Tab definition
  static final Map<String, _TabItem> _pageMap = {
    'dashboard': _TabItem(Icons.dashboard, 'Dashboard', DashboardScreen()),
    'users': _TabItem(Icons.person, 'Users',AdminUsersScreen()),
    'staff': _TabItem(Icons.admin_panel_settings, 'Staff', AdminsScreen()),
    'reports': _TabItem(Icons.bar_chart, 'Reports', ReportScreen()),
    'subscriptions': _TabItem(Icons.subscriptions, 'Subscriptions', SubscriptionsScreen()),
    'verify': _TabItem(Icons.verified, 'Verify',VerificationScreen()),
    'settings': _TabItem(Icons.settings, 'Settings', SettingsScreen()),
  };

  /// Build tabs dynamically from loginProvider
  List<_TabItem> _tabsFromLoginPages() {
    final userModel = ref.watch(loginProvider);
    final pages = userModel.data?.first.user?.pages ?? const [];

    final available = {
      for (final p in pages)
        if ((p.pages ?? '').trim().isNotEmpty) (p.pages!).toLowerCase().trim()
    };

    final orderedKeys =
        _desiredOrder.where((k) => available.contains(k)).toList();

    final tabs = <_TabItem>[];
    for (final key in orderedKeys) {
      final t = _pageMap[key];
      if (t != null) tabs.add(t);
    }

    if (tabs.isEmpty) {
      // fallback
      tabs.add(_pageMap['dashboard']!);
      tabs.add(_pageMap['settings']!);
    }
    return tabs;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tabs = _tabsFromLoginPages();

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [for (final t in tabs) t.page],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: DatingColors.darkGreen,
        selectedItemColor: DatingColors.white,
        unselectedItemColor: DatingColors.darkText,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          for (final t in tabs)
            BottomNavigationBarItem(icon: Icon(t.icon), label: t.label),
        ],
        selectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onPrimary.withOpacity(0.65),
        ),
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }
}

