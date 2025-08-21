import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, 'dashboardscreen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, 'adminusersscreen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, 'reportscreen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, 'subscriptionscreen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, 'swipesscreen');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, 'settingscreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
       backgroundColor: const Color(0xFFB6D430),
        selectedItemColor: const Color.fromARGB(255, 230, 224, 224),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
        BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: "Subscriptions"),
        BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: "swipes"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        
      ],
    );
  }
}
