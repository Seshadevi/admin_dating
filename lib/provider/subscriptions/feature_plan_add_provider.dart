import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
  }) => FeaturePlanAddState(
    loading: loading ?? this.loading,
    message: message,
    error: error,
  );
}

// Notifier
class FeaturePlanAddNotifier extends StateNotifier<FeaturePlanAddState> {
  FeaturePlanAddNotifier() : super(FeaturePlanAddState());

  Future<void> addFeatureToPlan({required int featureId, required int planTypeId}) async {
    state = state.copyWith(loading: true, message: null, error: null);
    try {
      final resp = await http.post(
        Uri.parse("http://97.74.93.26:6100/admin/featureplan"),
        headers: {"Content-Type": "application/json"},
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
}

// Provider
final featurePlanAddProvider =
StateNotifierProvider<FeaturePlanAddNotifier, FeaturePlanAddState>(
        (ref) => FeaturePlanAddNotifier());
