import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/screens/login.dart';
import 'package:admin_dating/screens/profile/dashboard.dart';
import 'package:admin_dating/screens/profile/notification.dart';
import 'package:admin_dating/screens/profile/report.dart';
import 'package:admin_dating/screens/profile/settings.dart';
import 'package:admin_dating/screens/profile/subscriptionscreem.dart';
import 'package:admin_dating/screens/profile/swipes.dart';
import 'package:admin_dating/screens/profile/users.dart';
import 'package:admin_dating/models/loginmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}


 class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
    @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final loginModel = ref.watch(loginProvider);
    final accessToken = loginModel.data;

    if (accessToken != null) {
      print("Access Token: $accessToken");
    } else {
      print("No access token found.");
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dating App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Consumer(builder: (context, ref, child) {
       
        print('token/main $accessToken');
        // // Check if the user has a valid refresh token
        if (accessToken != null && accessToken.isNotEmpty) {
          return const DashboardScreen(); // User is authenticated, redirect to Home
        } else {
          print('No valid refresh token, trying auto-login');
        }

        // / Attempt auto-login if refresh token is not available
            return FutureBuilder<bool>(
              future: ref
                  .read(loginProvider.notifier)
                  .tryAutoLogin(), // Attempt auto-login
              builder: (context, snapshot) {
                print(
                    'Token after auto-login attempt: $accessToken');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for auto-login to finish, show loading indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData &&
                    snapshot.data == true &&
                     ( accessToken != null && accessToken.isNotEmpty)
                     ) {
                  // If auto-login is successful and refresh token is available, go to Dashboard
                  return const DashboardScreen();
                } else {
                  // If auto-login fails or no token, redirect to LoginScreen
                  return LoginScreen();
                }
              },
            );
        
      }),
      routes: {
         "loginscreen": (context) => LoginScreen(),
         "reportscreen": (context) =>ReportScreen(),
         "dashboardscreen": (context) =>DashboardScreen(),
         "subscriptionscreen": (context) =>SubscriptionsScreen(),
         "settingscreen": (context) =>SettingsScreen(),
         "notificationscreen": (context) =>NotificationsScreen(),
         "swipesscreen": (context) =>SwipesScreen(),
         "usersscreen": (context) => UsersScreen(),
   
        
      },
    );
  }
}

