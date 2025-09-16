import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final fullPlanProvider =
StateNotifierProvider<FullPlanNotifier, FullPlanState>((ref) {
  return FullPlanNotifier();
});

class FullPlanState {
  final bool loading;
  final String? error;
  final bool success;

  FullPlanState({this.loading = false, this.error, this.success = false});

  FullPlanState copyWith({bool? loading, String? error, bool? success}) {
    return FullPlanState(
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class FullPlanNotifier extends StateNotifier<FullPlanState> {
  FullPlanNotifier() : super(FullPlanState());

  Future<String> postFullPlan({
    required int typeId,
    required String title,
    required int price,
    required int durationDays,
    required int quantity,
  }) async {
    state = state.copyWith(loading: true, error: null, success: false);

    final url = Uri.parse('http://97.74.93.26:6100/admin/plans/full');

    // Fetch token from SharedPreferences (if needed)
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    String? token;
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      token = userData['accessToken'] ??
          (userData['data'] != null &&
              userData['data'].isNotEmpty &&
              userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);
    }

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      "typeId": typeId,
      "title": title,
      "price": price,
      "durationDays": durationDays,
      "quantity": quantity,
    });

    try {
      final response =
      await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(loading: false, success: true, error: null);
        return "Plan created successfully";
      } else {
        final data = json.decode(response.body);
        state = state.copyWith(
            loading: false, success: false, error: data['message']);
        return data['message'] ?? "Failed to create plan.";
      }
    } catch (e) {
      state =
          state.copyWith(loading: false, success: false, error: e.toString());
      return 'Error: $e';
    }
  }
}
