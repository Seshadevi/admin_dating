import 'dart:convert';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/models/superAdminModels/admin_feature_model.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminFeatureProvider extends StateNotifier<AdminFeatureModel> {
  final Ref ref;
  AdminFeatureProvider(this.ref) : super(AdminFeatureModel.initial());

  /// 🔹 Get Features with token + refresh
  Future<void> getAdminFeatures() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      String? token = await _getToken(prefs);

      final client = _retryClient(prefs, token);

      final response = await client.get(
        Uri.parse(Dgapi.adminfeatures),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('Get AdminFeature Status Code: ${response.statusCode}');
      print('Get AdminFeature Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final features = AdminFeatureModel.fromJson(res);
        state = features;
        print('✅ AdminFeature fetched successfully');
      } else {
        throw Exception("Error fetching AdminFeature: ${response.body}");
      }
    } catch (e) {
      print("❌ Failed to fetch AdminFeature: $e");
    }
  }

  /// 🔹 Add Feature with token + refresh
  Future<bool> addAdminFeatures({
    required String featureName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? token = await _getToken(prefs);

      final client = _retryClient(prefs, token);

      final response = await client.post(
        Uri.parse(Dgapi.adminaddfeatures),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "featureName": featureName,
        }),
      );

      print('Post AdminFeatures Status Code: ${response.statusCode}');
      print('Post AdminFeatures Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getAdminFeatures(); // refresh list
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Failed to create AdminFeature: $e");
      return false;
    }
  }

  /// 🔹 Extract token from prefs (with fallback)
  Future<String?> _getToken(SharedPreferences prefs) async {
    String? userDataString = prefs.getString('userData');
    if (userDataString == null || userDataString.isEmpty) {
      throw Exception("User token missing. Please log in again.");
    }

    final Map<String, dynamic> userData = jsonDecode(userDataString);

    String? token = userData['accessToken'] ??
        (userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null);

    if (token == null || token.isEmpty) {
      throw Exception("User token invalid. Please log in again.");
    }

    return token;
  }

  /// 🔹 Retry client with refresh logic
  RetryClient _retryClient(SharedPreferences prefs, String? token) {
    return RetryClient(
      http.Client(),
      retries: 3,
      when: (res) => res.statusCode == 401 || res.statusCode == 400,
      onRetry: (req, res, retryCount) async {
        if (retryCount == 0 &&
            (res?.statusCode == 401 || res?.statusCode == 400)) {
          print("⚠️ Token expired, refreshing...");
          String? newAccessToken =
              await ref.read(loginProvider.notifier).restoreAccessToken();

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await prefs.setString('accessToken', newAccessToken);
            req.headers['Authorization'] = 'Bearer $newAccessToken';
            print("🔄 New Token: $newAccessToken");
          }
        }
      },
    );
  }
}

final adminFeatureProvider =
    StateNotifierProvider<AdminFeatureProvider, AdminFeatureModel>((ref) {
  return AdminFeatureProvider(ref);
});
