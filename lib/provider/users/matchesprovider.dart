import 'dart:convert';

import 'package:admin_dating/models/users/Matchesmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Matchesprovider extends StateNotifier<Matchesmodel> {
  final Ref ref;
  Matchesprovider(this.ref) : super(Matchesmodel.initial());

  // Modified method to accept optional token parameter
  Future<void> getMatches({String? specificToken}) async {
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

      print('Fetching Matches..');

      final response = await http.get(
        Uri.parse(Dgapi.matchesget),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      final responseBody = response.body;
      print('Get Matches Status Code: ${response.statusCode}');
      print('Get Matches Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Matchesmodel.fromJson(res);
          state = usersData;
          print('Successfully fetched Matches data');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Matches data");
        }
      } else {
        print("Error fetching Matches: ${response.body}");
        throw Exception("Error fetching Matches: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Matches: $e");
      // Set error state or handle error appropriately
      state = state.copyWith(
        success: false,
        message: e.toString(),
      );
    } finally {
      loadingState.state = false;
    }
  }

}

final matchesprovider =
    StateNotifierProvider<Matchesprovider, Matchesmodel>((ref) {
  return Matchesprovider(ref);
});
