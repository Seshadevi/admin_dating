
import 'package:admin_dating/screens/login.dart';
import 'package:admin_dating/screens/profile/dashboard.dart';
import 'package:admin_dating/screens/profile/notification.dart';
import 'package:admin_dating/screens/profile/report.dart';
import 'package:admin_dating/screens/profile/settings.dart';
import 'package:admin_dating/screens/profile/subscriptionscreem.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LoginScreen(),
      routes: {
         "loginscreen": (context) => LoginScreen(),
         "reportscreen": (context) =>ReportScreen(),
         "dashboardscreen": (context) =>DashboardScreen(),
         "subscriptionscreen": (context) =>SubscriptionsScreen(),
         "settingscreen": (context) =>SettingsScreen(),
         "notificationscreen": (context) =>NotificationsScreen(),
   
        
      },
    );
  }
}