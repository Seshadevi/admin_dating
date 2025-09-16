import 'dart:convert';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State
class FeaturePlanAddState {
  final bool loading;
  final String? message;
  final String? error;
  FeaturePlanAddState({this.loading = false, this.message, this.error});

  FeaturePlanAddState copyWith({
    bool? loading,
    String? message,
    String? error,
  }) =>
      FeaturePlanAddState(
        loading: loading ?? this.loading,
        message: message,
        error: error,
      );
}

// Notifier
class FeaturePlanAddNotifier extends StateNotifier<FeaturePlanAddState> {
  final Ref ref;
  FeaturePlanAddNotifier(this.ref) : super(FeaturePlanAddState());

  Future<void> addFeatureToPlan({
    required int featureId,
    required int planTypeId,
  }) async {
    print('data.......$planTypeId');
    state = state.copyWith(loading: true, message: null, error: null);
    final prefs = await SharedPreferences.getInstance();

    try {
      String? token = await _getToken(prefs);

      final client = _retryClient(prefs, token);

      final resp = await client.post(
        Uri.parse("http://97.74.93.26:6100/admin/featureplan"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "featureId": featureId,
          "planTypeId": planTypeId,
        }),
      );

      final jsonResp = json.decode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        state = state.copyWith(
          loading: false,
          message: jsonResp['message'] ?? "Feature linked successfully",
          error: null,
        );
      } else {
        state = state.copyWith(
          loading: false,
          message: null,
          error: jsonResp['message'] ?? "Failed: ${resp.body}",
        );
      }
    } catch (e) {
      state = state.copyWith(
        loading: false,
        message: null,
        error: e.toString(),
      );
    }
  }

  /// 🔹 Extract accessToken from SharedPreferences
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

  /// 🔹 Retry client with refresh token logic
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

// Provider
final featurePlanAddProvider =
    StateNotifierProvider<FeaturePlanAddNotifier, FeaturePlanAddState>(
  (ref) => FeaturePlanAddNotifier(ref),
);
