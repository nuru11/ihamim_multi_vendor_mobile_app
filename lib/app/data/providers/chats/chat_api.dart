import 'package:dio/dio.dart';
import 'package:ihamim_multivendor/app/data/models/chat_message_model.dart';
import 'package:ihamim_multivendor/app/utils/constants/api_endpoint.dart';

class MessageApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiEndpoints.baseUrl),
  );

  // Send a message
  Future<MessageModel> sendMessage(int senderId, int receiverId, String text, String senderName, String receiverName) async {
    print("Sending message from sender name: $senderName Receiver name: $receiverName message: $text, senderId: $senderId, receiverId: $receiverId");
    final response = await _dio.post(
      ApiEndpoints.sendMessage,
      data: {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": text,
        "sender_name": senderName,
        "receiver_name": receiverName
      },
    );
    return MessageModel.fromJson(response.data);
  }

  // Get conversation between two users
  Future<List<MessageModel>> getConversation(int userId, int otherUserId) async {
    final response = await _dio.get("${ApiEndpoints.getConversation}/$userId/$otherUserId");
    print("Conversation response data: ${response.data}");
    return (response.data as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  // Get inbox (last messages)
  Future<List<MessageModel>> getInbox(int userId) async {
    final response = await _dio.get("${ApiEndpoints.getInbox}/$userId");
    print("Inbox response data: ${response.data}");
    return (response.data as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  // Mark messages as read
  // Future<void> markAsRead(int userId, int otherUserId) async {
  //   await _dio.put("${ApiEndpoints.markAsRead}/$userId/$otherUserId");
  // }

  Future<void> markAsRead(int userId, int otherUserId) async {
  final response = await _dio.put(
    "${ApiEndpoints.markAsRead}/$userId/$otherUserId",
  );
  if (response.statusCode != 200) {
    throw Exception("Failed to mark as read");
  }
}

}


// import 'package:dio/dio.dart';
// import 'package:ihamim_multivendor/app/data/models/chat_message_model.dart';

// class MessageApi {
//   final Dio _dio = Dio(BaseOptions(baseUrl: "http://192.168.109.3:4000/api"));

//   Future<MessageModel> sendMessage(int senderId, int receiverId, String text) async {
//     final res = await _dio.post("/messages/send", data: {
//       "senderId": senderId,
//       "receiverId": receiverId,
//       "message": text,
//     });
//     return MessageModel.fromJson(res.data);
//   }

//   Future<List<MessageModel>> getConversation(int userId, int otherUserId) async {
//     final res = await _dio.get("/messages/conversation", queryParameters: {
//       "userId": userId,
//       "otherUserId": otherUserId,
//     });
//     return (res.data as List).map((e) => MessageModel.fromJson(e)).toList();
//   }

//   Future<List<MessageModel>> getInbox(int userId) async {
//     final res = await _dio.get("/messages/inbox", queryParameters: {
//       "userId": userId,
//     });
//     return (res.data as List).map((e) => MessageModel.fromJson(e)).toList();
//   }

//   Future<void> markAsRead(int userId, int otherUserId) async {
//     await _dio.post("/messages/read", data: {
//       "userId": userId,
//       "otherUserId": otherUserId,
//     });
//   }
// }
