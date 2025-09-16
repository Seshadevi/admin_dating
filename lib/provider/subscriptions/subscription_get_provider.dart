import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final subscriptionListProvider = StateNotifierProvider<SubscriptionListNotifier, SubscriptionListState>(
      (ref) => SubscriptionListNotifier(),
);

class SubscriptionListState {
  final bool loading;
  final List<dynamic> plans;
  final String? error;

  SubscriptionListState({
    this.loading = false,
    this.plans = const [],
    this.error,
  });

  SubscriptionListState copyWith({
    bool? loading,
    List<dynamic>? plans,
    String? error,
  }) {
    return SubscriptionListState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      error: error,
    );
  }
}

class SubscriptionListNotifier extends StateNotifier<SubscriptionListState> {
  SubscriptionListNotifier() : super(SubscriptionListState());

  final String baseUrl = 'http://97.74.93.26:6100/admin/plan';

  Future<void> fetchPlans() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final url = Uri.parse('$baseUrl/get');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final plans = data['data'] ?? [];
        state = state.copyWith(loading: false, plans: plans);
      } else {
        state = state.copyWith(
            loading: false,
            error: 'Failed to load plans. Server error.');
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Failed to load plans. $e');
    }
  }

  Future<String> deletePlan(int id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Refresh list after deletion
        await fetchPlans();
        return "success";
      } else {
        return "Failed to delete plan.";
      }
    } catch (e) {
      return "Error deleting plan: $e";
    }
  }
}
