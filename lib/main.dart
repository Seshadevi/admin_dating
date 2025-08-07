import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/screens/login.dart';
import 'package:admin_dating/screens/profile/add_proffile_screen.dart';
import 'package:admin_dating/screens/profile/dashboard.dart';
import 'package:admin_dating/screens/profile/notification.dart';
import 'package:admin_dating/screens/profile/report.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/causesget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/causespost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/defaultmesagesget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/defaultmesagespost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/dringkingget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/dringkingpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/genderget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/genderpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/interestsgetscren.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/interestspost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/kidsget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/kidspost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/languagesget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/languagespost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/lookingforgetscreen.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/lookingforpostscreen.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/modegetscreen.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/modepost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/qualitiesGet.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/qualitiespost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/religionget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/religionpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/starsignget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/starsignpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/termsandconditionpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/termsandconditionsget.dart';
import 'package:admin_dating/screens/settings/postadmin.dart';
import 'package:admin_dating/screens/settings/settings.dart';
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
         "/addprofilescreen": (context) => AddProfileScreen(),
         '/postadminscreen': (context) => PostAdminScreen(),
        '/lookingforgetscreen':(context)=>LookingForGetScreen(),
        '/lookingforpost':(context)=>Lookingforpostscreen(),
        '/drinkingpost':(context)=>Drinkingpostscreen(),
        '/drinkingget':(context)=>DrinkingGetScreen(),
        '/genderpost':(context)=>Genderpostscreen(),
        '/genderget':(context)=>GenderGetScreen(),
        '/interestpost':(context)=>Interestspostscreen(),
        '/interestget':(context)=>interestsGetScreen(),
        '/kidsget':(context)=>kidsGetScreen(),
        '/kidspost':(context)=>kidspostscreen(),
        '/modesget':(context)=>ModeGetScreen(),
        '/modespost':(context)=>Modepostscreen(),
        '/qualitiesget':(context)=>QualitiesGetScreen(),
        '/qualitiespost':(context)=>Qualitiespostscreen(),
        '/causesget':(context)=>CausesGetScreen(),
        '/causespost':(context)=>Causespostscreen(),
        '/defaultmessagespost':(context)=>DefaultMesagespostscreen(),
        '/defaultmessagesget':(context)=>DefaultMesagesGetScreen(),
        '/religionget':(context)=>ReligionGetScreen(),
        '/religionpost':(context)=>Religionpostscreen(),
        '/termsget':(context)=>TermsAndConditionGetScreen(),
        '/termspost':(context)=>TermsAndConditionspostscreen(),
        '/starsignpost':(context)=>Starsignpostscreen(),
        '/starsignget':(context)=>StarsignGetScreen(),
        '/languagesget':(context)=>LanguagesGetScreen(),
        '/languagespost':(context)=>Languagespostscreen(),
        // '/':(context)=>(),
        // '/':(context)=>(),
        // '/':(context)=>(),
   
        
      },
    );
  }
}

