// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomBottomNavBar extends ConsumerStatefulWidget {
//   final int currentIndex;

//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//   });

//   @override
//   ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
//   void _onTap(BuildContext context, int index) {
//     if (index == widget.currentIndex) return;

//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, 'dashboardscreen');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, 'adminusersscreen');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, 'reportscreen');
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, 'subscriptionscreen');
//         break;
//       case 4:
//         Navigator.pushReplacementNamed(context, 'swipesscreen');
//         break;
//       case 5:
//         Navigator.pushReplacementNamed(context, 'settingscreen');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     final userModel = ref.watch(loginProvider);
//     final role = userModel.data?.first.user?.role;
//     return BottomNavigationBar(
//       currentIndex: widget.currentIndex,
//        backgroundColor: const Color(0xFFB6D430),
//         selectedItemColor: const Color.fromARGB(255, 230, 224, 224),
//         unselectedItemColor: Colors.black54,
//         type: BottomNavigationBarType.fixed,
//       onTap: (index) => _onTap(context, index),
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
//         BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
//         BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: "Subscriptions"),
//         BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: "verify"),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        
//       ],
//     );
//   }
// }








import 'package:admin_dating/provider/loginprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TabItem {
  final IconData icon;
  final String label;
  final String route;
  const _TabItem(this.icon, this.label, this.route);
}

class CustomBottomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  List<_TabItem> _tabsForRole(String? role) {
    final r = (role ?? '').toLowerCase();

    if (r == 'superadmin') {
      // Super Admin layout (6 tabs)
      return const [
        _TabItem(Icons.dashboard, 'Dashboard', 'dashboardscreen'),
        _TabItem(Icons.admin_panel_settings, 'Admins', 'superadmincreatedadminsscreen'),
        _TabItem(Icons.bar_chart, 'Reports', 'reportscreen'),
        _TabItem(Icons.subscriptions, 'Subscriptions', 'subscriptionscreen'),
        _TabItem(Icons.verified, 'Verify', 'swipesscreen'),
        _TabItem(Icons.settings, 'Setting', 'settingscreen'),
      ];
    }

    // Admin layout (4 tabs)
    return const [
      _TabItem(Icons.dashboard, 'Dashboard', 'dashboardscreen'),
      _TabItem(Icons.person, 'Users', 'adminusersscreen'),
      _TabItem(Icons.verified, 'Verify', 'swipesscreen'),
      _TabItem(Icons.settings, 'Setting', 'settingscreen'),
    ];
  }

  void _onTap(BuildContext context, List<_TabItem> tabs, int index) {
    if (index < 0 || index >= tabs.length) return;
    final targetRoute = tabs[index].route;

    // If we’re already on this route, do nothing
    if (ModalRoute.of(context)?.settings.name == targetRoute) return;

    Navigator.pushReplacementNamed(context, targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(loginProvider);
    final role = userModel.data?.first.user?.role;

    final tabs = _tabsForRole(role);
    final safeIndex = widget.currentIndex.clamp(0, tabs.length - 1);

    return BottomNavigationBar(
      currentIndex: safeIndex,
      backgroundColor: const Color(0xFFB6D430),
      selectedItemColor: const Color.fromARGB(255, 230, 224, 224),
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onTap(context, tabs, index),
      items: [
        for (final t in tabs) BottomNavigationBarItem(icon: Icon(t.icon), label: t.label),
      ],
    );
  }
}

