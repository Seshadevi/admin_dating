class AdminChatMessage {
  final int id;
  final int matchId;
  final int senderId;
  final int receiverId;
  final String? message;
  final List<dynamic>? media; // Support for image/media data
  final String type;
  final DateTime timestamp;

  AdminChatMessage({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.receiverId,
    this.message,
    this.media,
    required this.type,
    required this.timestamp,
  });

  factory AdminChatMessage.fromJson(Map<String, dynamic> json) {
    // Handle media field which can be array or single item
    List<dynamic>? mediaList;
    if (json['media'] != null) {
      if (json['media'] is List) {
        mediaList = json['media'];
      } else if (json['media'] is Map || json['media'] is String) {
        mediaList = [json['media']];
      }
    }

    return AdminChatMessage(
      id: json['id'] ?? 0,
      matchId: json['matchId'] ?? 0,
      senderId: json['senderId'] ?? 0,
      receiverId: json['receiverId'] ?? 0,
      message: json['message'],
      media: mediaList,
      type: json['type'] ?? 'text',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'media': media,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Helper method to check if message has images
  bool get hasImages => media != null && media!.isNotEmpty;

  // Helper method to get image URLs - FIXED to handle backend format
  List<String> get imageUrls {
    if (!hasImages) return [];
    return media!.map((item) {
      // Handle backend format: {url, name, size, mime}
      if (item is Map<String, dynamic>) {
        return item['url']?.toString() ?? '';
      }
      // Handle direct string URLs
      return item.toString();
    }).where((url) => url.isNotEmpty).toList();
  }

  // NEW: Helper method to get media objects with metadata
  List<MediaItem> get mediaItems {
    if (!hasImages) return [];
    return media!.map((item) {
      if (item is Map<String, dynamic>) {
        return MediaItem(
          url: item['url']?.toString() ?? '',
          name: item['name']?.toString(),
          size: item['size'],
          mime: item['mime']?.toString(),
        );
      }
      return MediaItem(url: item.toString());
    }).where((item) => item.url.isNotEmpty).toList();
  }

  AdminChatMessage copyWith({
    int? id,
    int? matchId,
    int? senderId,
    int? receiverId,
    String? message,
    List<dynamic>? media,
    String? type,
    DateTime? timestamp,
  }) {
    return AdminChatMessage(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      media: media ?? this.media,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'AdminChatMessage(id: $id, senderId: $senderId, receiverId: $receiverId, message: $message, media: $media, type: $type, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminChatMessage &&
        other.id == id &&
        other.matchId == matchId &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.message == message &&
        other.type == type &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        matchId.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        message.hashCode ^
        type.hashCode ^
        timestamp.hashCode;
  }
}

// NEW: Media item class to handle backend format
class MediaItem {
  final String url;
  final String? name;
  final int? size;
  final String? mime;

  MediaItem({
    required this.url,
    this.name,
    this.size,
    this.mime,
  });

  bool get isBase64 => url.startsWith('data:image');
  bool get isNetworkUrl => url.startsWith('http');
}