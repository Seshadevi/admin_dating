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

  Future<void> getLikeanddislike() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    try {
      loadingState.state = true;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken; // ✅ Update token for next use
            req.headers['Authorization'] = 'Bearer $newAccessToken';

            print("New Token: $newAccessToken");
          }
        },
      );

      print('get Likeanddislike');

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
          print('get Likeanddislike successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Likeanddislike");
        }
      } else {
        print("Error fetching Admincreatedusers${response.body}");
        throw Exception("Error fetching Admincreatedusers: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Admincreatedusers: $e");
    } finally {
      loadingState.state = false;
    }
  }
}

final likeanddislikeprovider =
    StateNotifierProvider<Likeanddislikeprovider, Likeansdislikemodel>((ref) {
  return Likeanddislikeprovider(ref);
});
