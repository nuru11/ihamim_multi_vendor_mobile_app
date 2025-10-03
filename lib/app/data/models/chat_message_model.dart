class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final bool isRead;
  final String senderName;
  final String receiverName;
  final DateTime createdAt;
  final int unreadCount;

  // 👇 New fields
  final String? fileUrl;   // For file uploads (images, docs, etc.)
  final String type;       // "text", "image", "file"

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.senderName,
    required this.receiverName,
    required this.createdAt,
    required this.unreadCount,
    this.fileUrl,
    this.type = "text",
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      message: json["message"] ?? '',
      isRead: json["is_read"] == true || json["is_read"] == 1,
      senderName: json["sender_name"] ?? '',
      receiverName: json["receiver_name"] ?? '',
      createdAt: DateTime.parse(json["created_at"]),
      unreadCount: (json["unread_count"] ?? json["unreadCount"] ?? 0) as int,

      // 👇 File support
      fileUrl: json["file_url"] ?? json["fileUrl"],
      type: json["type"] ?? "text",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "is_read": isRead ? 1 : 0,
      "sender_name": senderName,
      "receiver_name": receiverName,
      "created_at": createdAt.toIso8601String(),
      "unread_count": unreadCount,

      // 👇 File support
      "file_url": fileUrl,
      "type": type,
    };
  }

  MessageModel copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    String? message,
    bool? isRead,
    String? senderName,
    String? receiverName,
    DateTime? createdAt,
    int? unreadCount,
    String? fileUrl,
    String? type,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      createdAt: createdAt ?? this.createdAt,
      unreadCount: unreadCount ?? this.unreadCount,
      fileUrl: fileUrl ?? this.fileUrl,
      type: type ?? this.type,
    );
  }
}
