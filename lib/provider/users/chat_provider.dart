// provider/chat_admin_provider.dart
import 'dart:async';
import 'package:admin_dating/models/users/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Parameters for a chat session
class AdminChatParams {
  final String accessToken;
  final int peerUserId;
  const AdminChatParams({required this.accessToken, required this.peerUserId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminChatParams &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          peerUserId == other.peerUserId;

  @override
  int get hashCode => accessToken.hashCode ^ peerUserId.hashCode;
}

/// UI flags
final adminTypingProvider = StateProvider.family<bool, int>((_, __) => false);
final adminPresenceProvider =
    StateProvider.family<({bool online, DateTime? lastSeen})?, int>((_, __) => null);

/// Chat messages provider
final adminChatProvider = StateNotifierProvider.family<AdminChatNotifier, 
    List<AdminChatMessage>, AdminChatParams>(
  (ref, params) => AdminChatNotifier(ref, params),
);

class AdminChatNotifier extends StateNotifier<List<AdminChatMessage>> {
  final Ref _ref;
  final AdminChatParams _params;
  
  IO.Socket? _socket;
  bool _connected = false;
  bool _initialized = false;
  
  Timer? _typingHideTimer;

  AdminChatNotifier(this._ref, this._params) : super([]) {
    _connect();
  }

  // ---------------- Socket Connection ----------------
  
  void _connect() {
    final token = _params.accessToken;
    if (token.isEmpty) {
      print("❌ Admin Chat: no access token");
      return;
    }

    print('🧠 Admin Chat: Connecting socket...');
    _socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

    _wireEvents();
    _socket!.connect();
  }

  void _wireEvents() {
    _socket!.onConnect((_) {
      _connected = true;
      print("✅ Admin Chat socket connected");
      
      // Load conversation history on connect
      Future.delayed(const Duration(milliseconds: 200), () {
        _socket?.emit('fetchMessages', {'withUserId': _params.peerUserId});
        _socket?.emit('getPresence', {'userIds': [_params.peerUserId]});
      });
    });

    // Self confirmation (messageSent)
    _socket!.on('messageSent', (data) {
      try {
        final msg = AdminChatMessage.fromJson(Map<String, dynamic>.from(data));
        if (_isForActivePeer(msg)) {
          state = [...state, msg];
        }
      } catch (e) {
        print("❌ Admin messageSent parse error: $e");
      }
    });

    // Incoming message from peer
    _socket!.on('receiveMessage', (data) {
      try {
        final msg = AdminChatMessage.fromJson(Map<String, dynamic>.from(data));
        if (_isForActivePeer(msg)) {
          state = [...state, msg];
        }
      } catch (e) {
        print("❌ Admin receiveMessage parse error: $e");
      }
    });

    // Chat history
    _socket!.on('chatHistory', (data) {
      try {
        final list = (data['messages'] as List)
            .map((m) => AdminChatMessage.fromJson(Map<String, dynamic>.from(m)))
            .toList();
        list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        state = list;
      } catch (e) {
        print("❌ Admin chatHistory parse error: $e");
      }
    });

    // ---------- Typing ----------
    _socket!.on('typing', (data) {
      final from = data['from'];
      if (from == _params.peerUserId) {
        _ref.read(adminTypingProvider(_params.peerUserId).notifier).state = true;
        _typingHideTimer?.cancel();
        _typingHideTimer = Timer(const Duration(seconds: 2), () {
          _ref.read(adminTypingProvider(_params.peerUserId).notifier).state = false;
        });
      }
    });

    // ---------- Presence (single) ----------
    _socket!.on('presence', (data) {
      if (data['userId'] == _params.peerUserId) {
        final online = data['online'] == true;
        DateTime? last;
        if (data['lastSeen'] != null) {
          last = DateTime.parse(data['lastSeen']);
        }
        _ref.read(adminPresenceProvider(_params.peerUserId).notifier).state =
            (online: online, lastSeen: last);
      }
    });

    // ---------- Presence (batch) ----------
    _socket!.on('presenceBatch', (map) {
      final p = map['${_params.peerUserId}'];
      if (p == null) return;
      final online = p['online'] == true;
      DateTime? last;
      if (p['lastSeen'] != null) {
        last = DateTime.parse(p['lastSeen']);
      }
      _ref.read(adminPresenceProvider(_params.peerUserId).notifier).state =
          (online: online, lastSeen: last);
    });

    // ---------- Error Handling ----------
    _socket!.onError((err) => print('ℹ️ Admin Chat socket error: $err'));
    _socket!.onConnectError((err) => print('ℹ️ Admin Chat connect error: $err'));

    _socket!.onDisconnect((_) {
      _connected = false;
      print("🔌 Admin Chat socket disconnected");
    });

    _initialized = true;
  }

  bool _isForActivePeer(AdminChatMessage msg) {
    // Messages between admin and this specific peer
    return msg.senderId == _params.peerUserId || 
           msg.receiverId == _params.peerUserId;
  }

  void _teardown() {
    try {
      _socket?.off('messageSent');
      _socket?.off('receiveMessage');
      _socket?.off('chatHistory');
      _socket?.off('typing');
      _socket?.off('presence');
      _socket?.off('presenceBatch');
      _socket?.offAny();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _connected = false;
  }

  // ---------------- Public API ----------------

  /// Load conversation history
  void fetchMessages() {
    if (!_connected) return;
    _socket?.emit('fetchMessages', {'withUserId': _params.peerUserId});
    _socket?.emit('getPresence', {'userIds': [_params.peerUserId]});
  }

  /// Send text message
  void sendMessage(String text) {
    if (text.trim().isEmpty || !_connected) return;
    
    _socket?.emit('sendMessage', {
      'receiverId': _params.peerUserId,
      'message': text.trim(),
      'type': 'text',
      'fromAdmin': true, // Optional: if backend needs to know it's from admin
    });
  }

  /// Send image message with optional caption
  void sendImageMessage({
    required List<String> media,
    String? message,
  }) {
    if (!_connected) {
      print("❌ Cannot send image: socket not connected");
      return;
    }

    _socket?.emit('sendMessage', {
      'receiverId': _params.peerUserId,
      'media': media,
      'message': message ?? '',
      'type': 'image',
      'fromAdmin': true, // Optional: if backend needs to know it's from admin
    });
  }

  /// Send typing indicator
  void sendTyping() {
    if (!_connected) return;
    _socket?.emit('typing', {'to': _params.peerUserId});
  }

  @override
  void dispose() {
    _typingHideTimer?.cancel();
    _teardown();
    super.dispose();
  }
}