
import 'package:admin_dating/models/users/otheruserlikedpersonsmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedUsersprovider extends StateNotifier<LikedUsersModel> {
  final Ref ref;
  LikedUsersprovider(this.ref) : super(LikedUsersModel.initial());

  Future<void> getLikedUsers( {String? specificToken}) async {
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

      print('Fetching Likedpeples...');


      // ✅ Now use the possibly updated token here
      final response = await client.get(
        Uri.parse(Dgapi.likeDislikeget),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseBody = response.body;

      print('Get likeduser Status Code: ${response.statusCode}');
      print('Get likedusers Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = LikedUsersModel.fromJson(res);
          state = usersData;

         

          print("likedusers fetched successfully: ${usersData}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing peoples.");
        }
      } else {
        print("Error fetching likedusers: ${response.body}");
        throw Exception("Error fetching plans: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch likedusers: $e");
    } finally {
      loadingState.state = false;
    }
  }
}

final likedUsersprovider =
    StateNotifierProvider<LikedUsersprovider, LikedUsersModel>((ref) {
  return LikedUsersprovider(ref);
});
