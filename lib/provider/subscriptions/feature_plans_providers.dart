import 'dart:convert';
import 'package:admin_dating/models/supscription/feature_plans_model.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/models/superAdminModels/admin_feature_model.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeaturePlansProviders extends StateNotifier<FeatureplansModel> {
  final Ref ref;
  FeaturePlansProviders(this.ref) : super(FeatureplansModel.initial());

  /// 🔹 Get Features with token + refresh
  Future<void> getFeaturesPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final accesstoken = ref.read(loginProvider).data![0].accessToken;
    try {
      // String? token = await _getToken(prefs);

      final client = _retryClient(prefs, accesstoken);

      final response = await client.get(
        Uri.parse(Dgapi.getandAddFeatureplans),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accesstoken",
        },
      );

      print('Get Feature Plans Status Code: ${response.statusCode}');
      print('Get Feature Plans Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final features = FeatureplansModel.fromJson(res);
        state = features;
        print('✅ Feature Plans fetched successfully');
      } else {
        throw Exception("Error fetching Feature Plans: ${response.body}");
      }
    } catch (e) {
      print("❌ Failed to fetch Feature Plans: $e");
    }
  }

  // /// 🔹 Add Feature with token + refresh
   Future<bool> addFeatureToPlan({
    required int featureId,
    required int planTypeId,

  }) async {

    final prefs = await SharedPreferences.getInstance();
    final accesstoken = ref.read(loginProvider).data![0].accessToken;

    try {
      // String? token = await _getToken(prefs);

       if (accesstoken == null || accesstoken.isEmpty) {
         throw Exception("User token invalid. Please log in again.");
       }

      final client = _retryClient(prefs,accesstoken);

      final response = await client.post(
        Uri.parse(Dgapi.getandAddFeatureplans),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accesstoken",
        },
        body: jsonEncode({
          "featureId": featureId,
          "planTypeId": planTypeId,
        }),
      );

      print('Post Feature Plans Status Code: ${response.statusCode}');
      print('Post Feature Plans Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getFeaturesPlans(); // refresh list
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Failed to create Feature Plans: $e");
      return false;
    }
  }




/// 🔹 Update Feature with token + refresh
Future<bool> updateFeatureplans({
  required int featureId, // id of the feature to update
  required String featureName,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final accesstoken = ref.read(loginProvider).data![0].accessToken;

  try {
    if (accesstoken == null || accesstoken.isEmpty) {
      throw Exception("User token invalid. Please log in again.");
    }

    final client = _retryClient(prefs, accesstoken);

    final response = await client.put(
      Uri.parse('${Dgapi.updateandDeleteFeatureplans}/$featureId'), // assuming your API requires featureId in the URL
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accesstoken",
      },
      body: jsonEncode({
        "featureName": featureName,
      }),
    );

    print('PUT Feature Plans Status Code: ${response.statusCode}');
    print('PUT Feature Plans Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getFeaturesPlans(); // refresh list
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("❌ Failed to update Feature Plans: $e");
    return false;
  }
}


/// 🔹 Delete Feature by ID with token + refresh
Future<bool> deleteFeaturePlans({
  required int featureId, // id of the feature to delete
}) async {
  final prefs = await SharedPreferences.getInstance();
  final accesstoken = ref.read(loginProvider).data![0].accessToken;

  try {
    if (accesstoken == null || accesstoken.isEmpty) {
      throw Exception("User token invalid. Please log in again.");
    }

    final client = _retryClient(prefs, accesstoken);

    final response = await client.delete(
      Uri.parse('${Dgapi.updateandDeleteFeatureplans}/$featureId'), // API expects featureId in URL
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accesstoken",
      },
    );

    print('DELETE Feature Plans Status Code: ${response.statusCode}');
    print('DELETE Feature Plans Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      await getFeaturesPlans(); // refresh list
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("❌ Failed to delete Feature Plans: $e");
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
  RetryClient _retryClient(SharedPreferences prefs, String? accesstoken) {
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

final featurePlansProviders =
    StateNotifierProvider<FeaturePlansProviders, FeatureplansModel>((ref) {
  return FeaturePlansProviders(ref);
});
