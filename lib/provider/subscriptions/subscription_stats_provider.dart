import 'package:admin_dating/models/supscription/subscriptions_model.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/provider/subscriptions/subscription_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


final subscriptionStatsProvider =
    StateNotifierProvider<SubscriptionStatsNotifier, AsyncValue<SubscriptionsModel>>(
  (ref) => SubscriptionStatsNotifier(ref),
);

class SubscriptionStatsNotifier extends StateNotifier<AsyncValue<SubscriptionsModel>> {
  final Ref ref;
  SubscriptionSocketService? _service;

  SubscriptionStatsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = ref.read(loginProvider).data?[0].accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("User token invalid. Please log in again.");
      }

      _service = SubscriptionSocketService(ref: ref, accessToken: accessToken);

      // Fetch once
      _service!.getPlanStatistics((data) {
        state = AsyncValue.data(data);
      });

      // Listen for live updates
      _service!.listenPlanStatistics((data) {
        state = AsyncValue.data(data);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print("❌ Failed to initialize SubscriptionStatsNotifier: $e");
    }
  }

  @override
  void dispose() {
    _service?.dispose();
    super.dispose();
  }
}
