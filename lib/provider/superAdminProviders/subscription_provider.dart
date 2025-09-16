import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
      (ref) => SubscriptionNotifier(),
);

class SubscriptionState {
  final bool loading;
  final String? error;

  SubscriptionState({this.loading = false, this.error});

  SubscriptionState copyWith({bool? loading, String? error}) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(SubscriptionState());

  Future<String> postSubscriptionPlan(String planName, String description) async {
    state = state.copyWith(loading: true, error: null);

    final url = Uri.parse('http://97.74.93.26:6100/admin/plan/post');

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

    final body = json.encode({
      'planName': planName,
      'description': description,
    });

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        state = state.copyWith(loading: false, error: null);
        return "success";
      } else {
        state = state.copyWith(loading: false, error: data['message']);
        return data['message'] ?? 'Failed to add subscription.';
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return 'Error: $e';
    }
  }
}
