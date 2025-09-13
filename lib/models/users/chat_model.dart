// models/chat_admin_message.dart
class AdminChatMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String type;            // e.g. "text"
  final DateTime timestamp;

  const AdminChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  /// If your backend marks admin messages explicitly, adapt here.
  /// Otherwise, you can infer isFromAdmin by comparing senderId with the admin id
  /// (only if you have it). For now we keep model neutral.
  bool isFrom(int currentUserId) => senderId == currentUserId;

  factory AdminChatMessage.fromJson(Map<String, dynamic> j) {
    return AdminChatMessage(
      id: j['id'],
      senderId: j['senderId'],
      receiverId: j['receiverId'],
      message: j['message'] ?? '',
      type: j['type'] ?? 'text',
      timestamp: DateTime.parse(j['timestamp']),
    );
  }
}
