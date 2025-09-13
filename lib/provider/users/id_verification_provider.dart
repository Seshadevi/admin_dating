import 'dart:convert';
import 'package:admin_dating/models/users/id_verification_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Verificationprovider extends StateNotifier<List<VerificationId>> {
  final Ref ref;
  Verificationprovider(this.ref) : super(const []);

  /// Fetch verification users list (kept your naming pattern)
  Future<void> verificationid() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

      String? token;

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

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await prefs.setString('accessToken', newAccessToken);
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );

      print('Fetching verification ids');

      final response = await client.get(
        Uri.parse(Dgapi.getverification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseBody = response.body;
      print('Get verification Status Code: ${response.statusCode}');
      print('Get verification Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decoded = jsonDecode(responseBody);

          // Support: [ ... ], { data: [ ... ] }, or a single object
          final List<dynamic> rawList;
          if (decoded is List) {
            rawList = decoded;
          } else if (decoded is Map && decoded['data'] is List) {
            rawList = decoded['data'] as List;
          } else if (decoded is Map) {
            rawList = [decoded];
          } else {
            throw Exception("Unexpected response format");
          }

          final items = rawList
              .map((e) => VerificationId.fromJson(e as Map<String, dynamic>))
              .toList();

          state = items;
          print('Successfully fetched verification list (${items.length})');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing verification list");
        }
      } else {
        print("Error fetching verification ids: ${response.body}");
        throw Exception("Error fetching verification ids: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch verification ids: $e");
    } finally {
      loadingState.state = false;
    }
  }

  /// Approve/Reject user’s verification (verified: true/false)
  Future<bool> updateVerification({
    required int userId,
    required bool verified,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Get token (same way as above)
      String? token;
      final userDataString = prefs.getString('userData');
      if (userDataString != null && userDataString.isNotEmpty) {
        final Map<String, dynamic> userData = jsonDecode(userDataString);
        token = userData['accessToken'] ??
            (userData['data'] != null &&
                    (userData['data'] as List).isNotEmpty &&
                    userData['data'][0]['access_token'] != null
                ? userData['data'][0]['access_token']
                : null);
      }
      token ??= prefs.getString('accessToken');
      if (token == null || token.isEmpty) {
        // try refresh once
        token = await ref.read(loginProvider.notifier).restoreAccessToken();
        if (token == null || token.isEmpty) {
          throw Exception("Missing token. Please log in again.");
        }
        await prefs.setString('accessToken', token);
      }

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired during update, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await prefs.setString('accessToken', newAccessToken);
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );

      // "$baseUrl/admin/users/userId/verification" -> replace userId
      final url = Dgapi.updateverification.replaceFirst('userId', '$userId');
      print('Updating verification for userId=$userId -> $verified, URL=$url');

      final res = await client.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'verified': verified}),
      );

      print('Update Status Code: ${res.statusCode}');
      print('Update Response Body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
        // Optimistically update local state
        state = state
            .map((u) =>
                (u.userId == userId) ? u.copyWith(verified: verified) : u)
            .toList();
        return true;
      } else {
        throw Exception('Update failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      print('Failed to update verification: $e');
      return false;
    }
  }
}

final verificationIdProvider =
    StateNotifierProvider<Verificationprovider, List<VerificationId>>((ref) {
  return Verificationprovider(ref);
});
