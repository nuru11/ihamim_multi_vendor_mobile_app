// class MessageModel {
//   final int id;
//   final int senderId;
//   final int receiverId;
//   final String message;
//   final bool isRead;
//   final DateTime createdAt;

//   MessageModel({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       id: json['id'],
//       senderId: json['sender_id'],
//       receiverId: json['receiver_id'],
//       message: json['message'],
//       isRead: json['is_read'] == 1 || json['is_read'] == true,
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "sender_id": senderId,
//       "receiver_id": receiverId,
//       "message": message,
//       "is_read": isRead,
//       "created_at": createdAt.toIso8601String(),
//     };
//   }
// }

// class MessageModel {
//   final int id;
//   final int senderId;
//   final int receiverId;
//   final String message;
//   final bool isRead;
//   final String senderName;
//   final String receiverName;
//   final DateTime createdAt;

//   MessageModel({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.isRead,
//     required this.senderName,
//     required this.receiverName,
//     required this.createdAt,
//   });

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       id: json["id"],
//       senderId: json["sender_id"],
//       receiverId: json["receiver_id"],
//       message: json["message"],
//       isRead: json["is_read"] == true || json["is_read"] == 1,
//       senderName: json["sender_name"] ?? '',
//       receiverName: json["receiver_name"] ?? '',
//       createdAt: DateTime.parse(json["created_at"]),
//     );
//   }
// }



class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final bool isRead;
  final String senderName;
  final String receiverName;
  final DateTime createdAt;
  final int unreadCount; // new

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
    );
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
    );
  }
}
