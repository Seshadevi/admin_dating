import 'dart:convert';
import 'package:admin_dating/models/supscription/subscriptions_model.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionSocketService {
  late IO.Socket socket;
  final Ref ref;
  String accessToken;

  SubscriptionSocketService({required this.ref, required this.accessToken}) {
    _connect();
  }

  void _connect() {
    socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .enableForceNew()
          .build(),
    );

    socket.onConnect((_) => print('✅ Connected to WebSocket'));
    socket.onDisconnect((_) => print('❌ Disconnected from WebSocket'));
    socket.onConnectError((err) => print('⚠️ Connect error: $err'));
    socket.onError((err) => print('⚠️ Socket error: $err'));

    // Handle token expiration event from server (example event name: tokenExpired)
    socket.on('tokenExpired', (_) async {
      print('⚠️ Token expired. Refreshing...');
      await _refreshToken();
    });
  }

  Future<void> _refreshToken() async {
    final newAccessToken =
        await ref.read(loginProvider.notifier).restoreAccessToken();

    if (newAccessToken != null && newAccessToken.isNotEmpty) {
      accessToken = newAccessToken;
      print('🔄 New token: $accessToken');

      // Disconnect and reconnect with new token
      socket.dispose();
      _connect();
    } else {
      print('❌ Failed to refresh token. Please log in again.');
      socket.dispose();
    }
  }

  /// Fetch plan statistics once
  void getPlanStatistics(Function(SubscriptionsModel) onData) {
    socket.emit("getPlanStatistics");

    socket.on("planStatistics", (data) {
      try {
        final parsed = data is String ? jsonDecode(data) : data;
        final model = SubscriptionsModel.fromJson(parsed);
        onData(model);
      } catch (e) {
        print("❌ Parse error in SubscriptionsModel: $e");
      }
    });
  }

  /// Listen continuously for updates
  void listenPlanStatistics(Function(SubscriptionsModel) onData) {
    socket.on("planStatistics", (data) {
      // <-- fix here
      try {
        final parsed = data is String ? jsonDecode(data) : data;
        final model = SubscriptionsModel.fromJson(parsed);
        onData(model);
      } catch (e) {
        print("❌ Parse error in SubscriptionsModel: $e");
      }
    });
  }

  void dispose() {
    socket.dispose();
  }
}
