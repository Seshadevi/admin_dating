// provider/chat_admin_provider.dart
import 'dart:async';
import 'package:admin_dating/models/users/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


/// Parameters for a chat session
class AdminChatParams {
  final String accessToken; // from MatchesScreen
  final int peerUserId;     // the user admin chats with
  const AdminChatParams({required this.accessToken, required this.peerUserId});
}

/// UI flags (keyed by peer for safety if you open multiple chats)
final adminTypingProvider = StateProvider.family<bool, int>((_, __) => false);
final adminPresenceProvider =
    StateProvider.family<({bool online, DateTime? lastSeen})?, int>((_, __) => null);

/// Chat messages provider – family by (token, peerUserId)
final adminChatProvider = StateNotifierProvider.family<AdminChatNotifier, List<AdminChatMessage>, AdminChatParams>(
  (ref, params) => AdminChatNotifier(ref, params),
);

class AdminChatNotifier extends StateNotifier<List<AdminChatMessage>> {
  final Ref _ref;
  final AdminChatParams _params;
  late final IO.Socket _socket;

  bool _initialized = false;
  Timer? _typingHideTimer;

  AdminChatNotifier(this._ref, this._params) : super([]) {
    _initSocket();
  }

  void _initSocket() {
    if (_initialized) return;

    _socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': _params.accessToken})
          .enableForceNew()
          .build(),
    );

    _socket.onConnect((_) {
      // Load this conversation’s history
      _socket.emit('fetchMessages', {'withUserId': _params.peerUserId});
      // (Optional) presence
      _socket.emit('getPresence', {'userIds': [_params.peerUserId]});
    });

    // Outgoing acknowledgement (server echo)
    _socket.on('messageSent', (data) {
      final msg = AdminChatMessage.fromJson(Map<String, dynamic>.from(data));
      // only append if belongs to this peer
      if (_isForActivePeer(msg)) {
        state = [...state, msg];
      }
    });

    // Incoming message
    _socket.on('receiveMessage', (data) {
      final msg = AdminChatMessage.fromJson(Map<String, dynamic>.from(data));
      if (_isForActivePeer(msg)) {
        state = [...state, msg];
      }
    });

    // History
    _socket.on('chatHistory', (data) {
      final list = (data['messages'] as List)
          .map((m) => AdminChatMessage.fromJson(Map<String, dynamic>.from(m)))
          .toList();
      list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      state = list;
    });

    // Typing
    _socket.on('typing', (data) {
      final from = data['from'];
      if (from == _params.peerUserId) {
        _ref.read(adminTypingProvider(_params.peerUserId).notifier).state = true;
        _typingHideTimer?.cancel();
        _typingHideTimer = Timer(const Duration(seconds: 2), () {
          _ref.read(adminTypingProvider(_params.peerUserId).notifier).state = false;
        });
      }
    });

    // Presence (single)
    _socket.on('presence', (data) {
      if (data['userId'] == _params.peerUserId) {
        final online = data['online'] == true;
        final last = data['lastSeen'] != null ? DateTime.parse(data['lastSeen']) : null;
        _ref.read(adminPresenceProvider(_params.peerUserId).notifier).state =
            (online: online, lastSeen: last);
      }
    });

    // Presence (batch)
    _socket.on('presenceBatch', (map) {
      final p = map['${_params.peerUserId}'];
      if (p == null) return;
      final online = p['online'] == true;
      final last = p['lastSeen'] != null ? DateTime.parse(p['lastSeen']) : null;
      _ref.read(adminPresenceProvider(_params.peerUserId).notifier).state =
          (online: online, lastSeen: last);
    });

    _socket.onDisconnect((_) {});

    _initialized = true;
  }

  bool _isForActivePeer(AdminChatMessage msg) {
    // we only care about messages between admin and this peer
    // peer is either sender or receiver.
    return msg.senderId == _params.peerUserId || msg.receiverId == _params.peerUserId;
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _socket.emit('sendMessage', {
      'receiverId': _params.peerUserId,
      'message': text.trim(),
      'fromAdmin': true, // If your backend expects this flag; otherwise remove
    });
  }

  void sendTyping() {
    _socket.emit('typing', {'to': _params.peerUserId});
  }

  @override
  void dispose() {
    _typingHideTimer?.cancel();
    _socket.dispose();
    super.dispose();
  }
}
