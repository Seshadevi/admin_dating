import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/screens/login.dart';
import 'package:admin_dating/screens/profile/cat_report.dart';
import 'package:admin_dating/screens/settings/add_report_categories.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/sportsget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/sportspost.dart';
import 'package:admin_dating/screens/settings/report_categories.dart';
import 'package:admin_dating/screens/subscriptions/AddFeatureToPlanScreen.dart';
import 'package:admin_dating/screens/subscriptions/full_plans_get_page.dart';
import 'package:admin_dating/screens/subscriptions/get_feature_plans.dart';
import 'package:admin_dating/screens/subscriptions/subscription_plans_list_screen.dart';
import 'package:admin_dating/screens/superAdminScreens/add_admin_features.dart';
import 'package:admin_dating/screens/superAdminScreens/add_roles.dart';
import 'package:admin_dating/screens/superAdminScreens/createadminscreen.dart';
import 'package:admin_dating/screens/superAdminScreens/fetchadminscreen.dart';
import 'package:admin_dating/screens/superAdminScreens/get_admin_features.dart';
import 'package:admin_dating/screens/users/add_proffile_screen.dart';
import 'package:admin_dating/screens/profile/dashboard.dart';
import 'package:admin_dating/screens/profile/notification.dart';
import 'package:admin_dating/screens/profile/report.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/causesget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/causespost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/defaultmesagesget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/defaultmesagespost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/dringkingget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/dringkingpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/experienceget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/experiencepost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/genderget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/genderpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/industryget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/industrypost.dart';
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
import 'package:admin_dating/screens/settings/getsandpostsofadmin/relationshipget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/relationshippost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/religionget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/religionpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/starsignget.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/starsignpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/termsandconditionpost.dart';
import 'package:admin_dating/screens/settings/getsandpostsofadmin/termsandconditionsget.dart';
import 'package:admin_dating/screens/settings/postadmin.dart';
import 'package:admin_dating/screens/settings/settings.dart';
import 'package:admin_dating/screens/subscriptions/subscriptionscreem.dart';
import 'package:admin_dating/screens/profile/verfication_screen.dart';
import 'package:admin_dating/screens/profile/users.dart';
import 'package:admin_dating/screens/users/admincreateduserscreen.dart';
import 'package:admin_dating/screens/users/edit_profilescreen.dart';
import 'package:admin_dating/screens/users/likedislikescreen.dart';
import 'package:admin_dating/screens/users/likedpeoplesscreen.dart';
import 'package:admin_dating/screens/users/matchesscreen.dart';
import 'package:admin_dating/screens/users/realusersscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'constants/dating_colors.dart';

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
  @override
  Widget build(BuildContext context) {
    final loginModel = ref.watch(loginProvider);
    final isDarkMode = ref.watch(themeProvider); // Watch theme state
    final accessToken = loginModel.data;

    if (accessToken != null) {
      print("Access Token: $accessToken");
    } else {
      print("No access token found.");
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dating App',
      // Apply theme based on isDarkMode state
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Consumer(builder: (context, ref, child) {
        print('token/main $accessToken');

        // Check if the user has a valid access token
        if (accessToken != null && accessToken.isNotEmpty) {
          return const CustomBottomNavBar(); // User is authenticated, redirect to Dashboard
        } else {
          print('No valid access token, trying auto-login');
        }

        // Attempt auto-login if access token is not available
        return FutureBuilder<bool>(
          future: ref
              .read(loginProvider.notifier)
              .tryAutoLogin(), // Attempt auto-login
          builder: (context, snapshot) {
            print('Token after auto-login attempt: $accessToken');

            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for auto-login to finish, show loading indicator
              return Scaffold(
                backgroundColor: isDarkMode
                    ? const Color(0xFF121212)
                    : const Color(0xFFA5C63B),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData &&
                snapshot.data == true &&
                (accessToken != null && accessToken.isNotEmpty)) {
              // If auto-login is successful and access token is available, go to Dashboard
              return const CustomBottomNavBar();
            } else {
              // If auto-login fails or no token, redirect to LoginScreen
              return LoginScreen();
            }
          },
        );
      }),
      routes: {
        "loginscreen": (context) => LoginScreen(),
        "reportscreen": (context) => ReportScreen(),
        "dashboardscreen": (context) => DashboardScreen(),
        "superadmincreatedadminsscreen": (context) => AdminsScreen(),
        "subscriptionscreen": (context) => SubscriptionsScreen(),
        "settingscreen": (context) => SettingsScreen(),
        "notificationscreen": (context) => NotificationsScreen(),
        "swipesscreen": (context) => VerificationScreen(),
        "usersscreen": (context) => UsersScreen(),
        "adminusersscreen": (context) => AdminUsersScreen(),
        "/addprofilescreen": (context) => AddProfileScreen(),
        '/postadminscreen': (context) => PostAdminScreen(),
        '/lookingforgetscreen': (context) => LookingForGetScreen(),
        '/lookingforpost': (context) => Lookingforpostscreen(),
        '/drinkingpost': (context) => Drinkingpostscreen(),
        '/drinkingget': (context) => DrinkingGetScreen(),
        '/genderpost': (context) => Genderpostscreen(),
        '/genderget': (context) => GenderGetScreen(),
        '/interestpost': (context) => Interestspostscreen(),
        '/interestget': (context) => interestsGetScreen(),
        '/kidsget': (context) => kidsGetScreen(),
        '/kidspost': (context) => kidspostscreen(),
        '/modesget': (context) => ModeGetScreen(),
        '/modespost': (context) => Modepostscreen(),
        '/qualitiesget': (context) => QualitiesGetScreen(),
        '/qualitiespost': (context) => Qualitiespostscreen(),
        '/causesget': (context) => CausesGetScreen(),
        '/causespost': (context) => Causespostscreen(),
        '/defaultmessagespost': (context) => DefaultMesagespostscreen(),
        '/defaultmessagesget': (context) => DefaultMesagesGetScreen(),
        '/religionget': (context) => ReligionGetScreen(),
        '/religionpost': (context) => Religionpostscreen(),
        '/termsget': (context) => TermsAndConditionGetScreen(),
        '/termspost': (context) => TermsAndConditionspostscreen(),
        '/starsignpost': (context) => Starsignpostscreen(),
        '/starsignget': (context) => StarsignGetScreen(),
        '/languagesget': (context) => LanguagesGetScreen(),
        '/languagespost': (context) => Languagespostscreen(),
        '/industrypost': (context) => Industrypostscreen(),
        '/industryget': (context) => IndustryGetScreen(),
        '/relationshipget': (context) => RelationshipGetScreen(),
        '/relationshippost': (context) => Relationshippostscreen(),
        '/experienceget': (context) => ExperienceGetScreen(),
        '/experiencepost': (context) => Experiencepostscreen(),
        '/likesdislikesscreen': (context) => LikesDislikesScreen(),
        '/realusersscreen': (context) => RealUsersScreen(),
        '/matchesscreen': (context) => MatchesScreen(),
        '/editprofilesscreen': (context) => EditProfileScreen(),
        '/createadmin': (context) => CreateAccountScreen(),
        '/addroles': (context) => RolesScreen(),
        '/adminfeatures': (context) => GetAdminFeatures(),
        '/addadminfeatues': (context) => AddAdminFeatures(),
        // '/addfeaturetoplan': (context) => AddFeatureToPlanScreen(),
        '/SubscriptionPlansListScreen': (context) =>  SubscriptionPlansListScreen(),
        '/full_plan_get': (context) => FullPlansGetPage(),
        '/get_feature_plans': (context) => GetFeaturePlans(),
        '/get_report_categories': (context) => ReportCategories(),
        '/add_report_categories': (context) => AddReportCategories(),
          '/sportspost': (context) =>Sportspostscreen(),
        '/sportsget': (context) =>SportsGetScreen(),
        '/likedpeoplesscreen': (context) =>LikedpeoplesScreen(),
      },
    );
  }
}