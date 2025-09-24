import 'dart:convert';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

final subscriptionListProvider = StateNotifierProvider<SubscriptionListNotifier, SubscriptionListState>(
      (ref) => SubscriptionListNotifier(ref),
);

class SubscriptionListState {
  final bool loading;
  final List<dynamic> plans;
  final String? error;
  final String? message;

  SubscriptionListState({
    this.loading = false,
    this.plans = const [],
    this.error,
    this.message
  });

  SubscriptionListState copyWith({
    bool? loading,
    List<dynamic>? plans,
    String? error,
    String? message,
  }) {
    return SubscriptionListState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      error: error,
      message: message,
    );
  }
}

class SubscriptionListNotifier extends StateNotifier<SubscriptionListState> {
  final Ref ref;
  SubscriptionListNotifier(this.ref) : super(SubscriptionListState());

  final String baseUrl = 'http://97.74.93.26:6100/admin/plan';

  Future<void> fetchPlans() async {
    state = state.copyWith(loading: true, error: null);
    final prefs = await SharedPreferences.getInstance();

    try {
      String? token;

      /// 🔹 Load userData from SharedPreferences
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

      print('Retrieved Token: $token');

      /// 🔹 Create retry client with token refresh
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
              // ✅ Save and update token
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken;
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );

      final url = Uri.parse('$baseUrl/get');

      /// 🔹 Always send Authorization header
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetch Plans Status Code: ${response.statusCode}');
      print('Fetch Plans Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final plans = data['data'] ?? [];
        state = state.copyWith(loading: false, plans: plans);
        print("Plans fetched successfully ✅");
      } else {
        state = state.copyWith(
          loading: false,
          error: "Failed to load plans. Server error: ${response.body}",
        );
      }
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Failed to load plans. $e",
      );
      print("Fetch Plans Error: $e");
    }
  }



Future<String> updatePlan({
  required int planId,
  required String planName,
  required String description,
}) async {
  state = state.copyWith(loading: true, error: null);
  final prefs = await SharedPreferences.getInstance();

  try {
    String? token;

    /// 🔹 Load userData from SharedPreferences
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

    print('Retrieved Token: $token');

    /// 🔹 Create retry client with token refresh
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
            // ✅ Save and update token
            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
            print("New Token: $newAccessToken");
          }
        }
      },
    );

    /// 🔹 API URL with planId
    final url = Uri.parse("${Dgapi.plansupdate}/$planId");

    /// 🔹 Body data
    final body = jsonEncode({
      'planName': planName,
      'description': description,
    });

    /// 🔹 PUT request
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print('Update Plan Status Code: ${response.statusCode}');
    print('Update Plan Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      state = state.copyWith(loading: false, message: "Plan updated successfully ✅");
      print("Plan updated successfully ✅: $data");
      return "success";
      
    } else {
      state = state.copyWith(
        loading: false,
        error: "Failed to update plan. Server error: ${response.body}",
      );
      return "Failed to update plan. Server error: ${response.body}";
    }
 } catch (e) {
  state = state.copyWith(loading: false, error: e.toString());
  return "Failed to update plan. $e";
}

}



  Future<String> deletePlan(int id) async {
     state = state.copyWith(loading: true, error: null);
    final prefs = await SharedPreferences.getInstance();

    try {

    String? token;

    /// 🔹 Load userData from SharedPreferences
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

    print('Retrieved Token: $token');

    /// 🔹 Create retry client with token refresh
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
            // ✅ Save and update token
            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
            print("New Token: $newAccessToken");
          }
        }
      },
    );

      final url = Uri.parse('${Dgapi.plansdelete}/$id');
      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchPlans();
        return "success";
      } else {
        
        return "Failed to delete plan. ${response.body}";
      }
    } catch (e) {
      return "Error deleting plan: $e";
    }
  }
}
