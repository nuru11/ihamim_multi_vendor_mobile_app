
import 'package:ihamim_multivendor/app/data/models/chat_message_model.dart';
import 'package:ihamim_multivendor/app/data/providers/chats/chat_api.dart';

// class MessageRepository {
//   final MessageApi _api;

//   MessageRepository(this._api);

//   Future<MessageModel> sendMessage(int senderId, int receiverId, String text) {
//     return _api.sendMessage(senderId, receiverId, text);
//   }

//   Future<List<MessageModel>> getConversation(int userId, int otherUserId) {
//     return _api.getConversation(userId, otherUserId);
//   }

//   Future<List<MessageModel>> getInbox(int userId) {
//     return _api.getInbox(userId);
//   }

//   Future<void> markAsRead(int userId, int otherUserId) {
//     return _api.markAsRead(userId, otherUserId);
//   }
// }



class MessageRepository {
  final MessageApi _api;

  MessageRepository(this._api);

  Future<MessageModel> sendMessage(int senderId, int receiverId, String text, String senderName, String receiverName) {
    return _api.sendMessage(senderId, receiverId, text, senderName, receiverName);
  }

  Future<List<MessageModel>> getConversation(int userId, int otherUserId) {
    return _api.getConversation(userId, otherUserId);
  }

  Future<List<MessageModel>> getInbox(int userId) {
    return _api.getInbox(userId);
  }

  Future<void> markAsRead(int userId, int otherUserId) {
    return _api.markAsRead(userId, otherUserId);
  }

  
}