// import 'dart:convert';
// import 'package:admin_dating/models/users/admincreatedusersmodes.dart';
// import 'package:admin_dating/models/users/likeansdislikemodel.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:admin_dating/utils/dgapi.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/retry.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Likeanddislikeprovider extends StateNotifier<Likeansdislikemodel> {
//   final Ref ref;
//   Likeanddislikeprovider(this.ref) : super(Likeansdislikemodel.initial());

//   Future<void> getLikeanddislike() async {
//     final loadingState = ref.read(loadingProvider.notifier);
//     final prefs = await SharedPreferences.getInstance();
//     try {
//       loadingState.state = true;

//       String? userDataString = prefs.getString('userData');
//       if (userDataString == null || userDataString.isEmpty) {
//         throw Exception("User token is missing. Please log in again.");
//       }

//       final Map<String, dynamic> userData = jsonDecode(userDataString);

//       String? token = userData['accessToken'] ??
//           (userData['data'] != null &&
//                   (userData['data'] as List).isNotEmpty &&
//                   userData['data'][0]['access_token'] != null
//               ? userData['data'][0]['access_token']
//               : null);

//       if (token == null || token.isEmpty) {
//         throw Exception("User token is invalid. Please log in again.");
//       }

//       print('Retrieved Token: $token');

//       final client = RetryClient(
//         http.Client(),
//         retries: 3,
//         when: (response) =>
//             response.statusCode == 401 || response.statusCode == 400,
//         onRetry: (req, res, retryCount) async {
//           if (retryCount == 0 &&
//               (res?.statusCode == 401 || res?.statusCode == 400)) {
//             print("Token expired, refreshing...");
//             String? newAccessToken =
//                 await ref.read(loginProvider.notifier).restoreAccessToken();

//             await prefs.setString('accessToken', newAccessToken);
//             token = newAccessToken; // ✅ Update token for next use
//             req.headers['Authorization'] = 'Bearer $newAccessToken';

//             print("New Token: $newAccessToken");
//           }
//         },
//       );

//       print('get Likeanddislike');

//       final response = await client.get(
//         Uri.parse(Dgapi.likedislike),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       final responseBody = response.body;
//       print('Get Likeanddislike Status Code: ${response.statusCode}');
//       print('Get Likeanddislike Response Body: $responseBody');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           final res = jsonDecode(responseBody);
//           final usersData = Likeansdislikemodel.fromJson(res);
//           state = usersData;
//           print('get Likeanddislike successfully');
//         } catch (e) {
//           print("Invalid response format: $e");
//           throw Exception("Error parsing Likeanddislike");
//         }
//       } else {
//         print("Error fetching Admincreatedusers${response.body}");
//         throw Exception("Error fetching Admincreatedusers: ${response.body}");
//       }
//     } catch (e) {
//       print("Failed to fetch Admincreatedusers: $e");
//     } finally {
//       loadingState.state = false;
//     }
//   }
// }

// final likeanddislikeprovider =
//     StateNotifierProvider<Likeanddislikeprovider, Likeansdislikemodel>((ref) {
//   return Likeanddislikeprovider(ref);
// });





import 'dart:convert';
import 'package:admin_dating/models/users/admincreatedusersmodes.dart';
import 'package:admin_dating/models/users/likeansdislikemodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Likeanddislikeprovider extends StateNotifier<Likeansdislikemodel> {
  final Ref ref;
  Likeanddislikeprovider(this.ref) : super(Likeansdislikemodel.initial());

  // Modified method to accept optional token parameter
  Future<void> getLikeanddislike({String? specificToken}) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    print('acces token............$specificToken.');
    
    try {
      loadingState.state = true;
      
      String? token;

      // If a specific token is provided, use it directly
      if (specificToken != null && specificToken.isNotEmpty) {
        token = specificToken;
        print('Using provided token: $token');
      } else {
        // Fallback to the original logic
        String? userDataString = prefs.getString('userData');
        if (userDataString == null || userDataString.isEmpty) {
          throw Exception("User token is missing. Please log in again.");
        }

        final Map<String, dynamic> userData = jsonDecode(userDataString);

        token = userData['accessToken'] ??
            (userData['data'] != null &&
                    (userData['data'] as List).isNotEmpty &&
                    userData['data'][0]['access_token'] != null
                ? userData['data'][0]['access_token']
                : null);

        if (token == null || token.isEmpty) {
          throw Exception("User token is invalid. Please log in again.");
        }

        print('Retrieved Token from SharedPreferences: $token');
      }

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            
            // Only try to refresh if we're not using a specific token
            if (specificToken == null) {
              String? newAccessToken =
                  await ref.read(loginProvider.notifier).restoreAccessToken();
              
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken;
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              
              print("New Token: $newAccessToken");
            } else {
              print("Cannot refresh specific token, using original");
              req.headers['Authorization'] = 'Bearer $specificToken';
            }
          }
        },
      );

      print('Fetching Likes and Dislikes...');

      final response = await client.get(
        Uri.parse(Dgapi.likedislike),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      final responseBody = response.body;
      print('Get Likeanddislike Status Code: ${response.statusCode}');
      print('Get Likeanddislike Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Likeansdislikemodel.fromJson(res);
          state = usersData;
          print('Successfully fetched likes and dislikes data');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing likes and dislikes data");
        }
      } else {
        print("Error fetching likes and dislikes: ${response.body}");
        throw Exception("Error fetching likes and dislikes: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch likes and dislikes: $e");
      // Set error state or handle error appropriately
      state = state.copyWith(
        success: false,
        message: e.toString(),
      );
    } finally {
      loadingState.state = false;
    }
  }
  Future<String> addLikeDislike({
  String? specificToken,
  int? realuserid,
  String? swipedirection,
}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  print('data like or dislike... ');
  try {
    loadingState.state = true;

    final prefs = await SharedPreferences.getInstance();
    final apiUrl = Uri.parse(Dgapi.likedislikepost);
    String? token;

    if (specificToken != null && specificToken.isNotEmpty) {
      token = specificToken;
      print('Using provided token: $token');
    } else {
      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token from SharedPreferences: $token');
    }

    final client = RetryClient(http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
      if (retryCount == 0 &&
          (res?.statusCode == 401 || res?.statusCode == 400)) {
        print("Token expired, refreshing...");
        if (specificToken == null) {
          String? newAccessToken =
              await ref.read(loginProvider.notifier).restoreAccessToken();

          await prefs.setString('accessToken', newAccessToken);
          token = newAccessToken;
          req.headers['Authorization'] = 'Bearer $newAccessToken';

          print("New Token: $newAccessToken");
        }
      }
    });

    print('Fetching Likes and Dislikes...');

    final request = await client.post(
      apiUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'swipeDirection': swipedirection,
        'userId': realuserid,
      }),
    );

    print("likesresponse ---${request.body}");

    final responseBody = jsonDecode(request.body);
    final message = responseBody['message'] ?? 'Action completed successfully.';

    if (request.statusCode == 200 || request.statusCode == 201) {
      print("like or dislike added successfully!");
      return message; // ✅ return success message
    } else {
      throw Exception(message); // ✅ return error message
    }
  } catch (error) {
    print("Failed to add like or dislike : $error");
    return error.toString(); // ✅ return error text
  } finally {
    loadingState.state = false;
  }
}

}

final likeanddislikeprovider =
    StateNotifierProvider<Likeanddislikeprovider, Likeansdislikemodel>((ref) {
  return Likeanddislikeprovider(ref);
});
