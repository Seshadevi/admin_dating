import 'package:admin_dating/provider/loginprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/dating_colors.dart';

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
      return const [
        _TabItem(Icons.dashboard, 'Dashboard', 'dashboardscreen'),
        _TabItem(Icons.admin_panel_settings, 'Admins', 'superadmincreatedadminsscreen'),
        _TabItem(Icons.bar_chart, 'Reports', 'reportscreen'),
        _TabItem(Icons.subscriptions, 'Subscriptions', 'subscriptionscreen'),
        _TabItem(Icons.verified, 'Verify', 'swipesscreen'),
        _TabItem(Icons.settings, 'Setting', 'settingscreen'),
      ];
    }
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
    if (ModalRoute.of(context)?.settings.name == targetRoute) return;
    Navigator.pushReplacementNamed(context, targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final userModel = ref.watch(loginProvider);
    final role = userModel.data?.first.user?.role;
    final tabs = _tabsForRole(role);
    final safeIndex = widget.currentIndex.clamp(0, tabs.length - 1);

    return BottomNavigationBar(
      currentIndex: safeIndex,
      backgroundColor: DatingColors.darkGreen,                // Uses your primaryGreen from DatingColors
      selectedItemColor: DatingColors.white,             // Typically white for contrast
      unselectedItemColor: DatingColors.darkText,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onTap(context, tabs, index),
      items: [
        for (final t in tabs)
          BottomNavigationBarItem(
            icon: Icon(t.icon),
            label: t.label,
          ),
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
    );
  }
}
