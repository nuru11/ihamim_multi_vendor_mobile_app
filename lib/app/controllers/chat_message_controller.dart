import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/multipart/multipart_file.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import '../data/models/chat_message_model.dart';
import '../data/repositories/message_repository.dart';

class MessageController extends GetxController {
  final MessageRepository _repository;
  IO.Socket? socket;

  var messages = <MessageModel>[].obs;
  var inbox = <MessageModel>[].obs;
  var isLoading = false.obs;
  var isOtherUserTyping = false.obs;

  var isLoadingConversation = false.obs;
var isLoadingInbox = false.obs;


  // default to -1 (no chat open)
  int currentChatUserId = -1;

  MessageController(this._repository);

  void setCurrentChatUser(int userId) {
    currentChatUserId = userId;
  }

  void initSocket(int userId) {
    if (socket != null && socket!.connected) return;

    socket = IO.io(
      "http://192.168.1.14:4000",
      IO.OptionBuilder().setTransports(["websocket"]).enableAutoConnect().build(),
    );

    socket!.onConnect((_) {
      print("Connected to socket server");
      socket!.emit("join", userId);
    });

    socket!.off("new_message");
    socket!.on("new_message", (data) {
  final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
  messages.add(msg);
  final user = GetStorage().read("user") ?? {};
  final loggedInUserId = user["id"];

  if (currentChatUserId == msg.senderId || currentChatUserId == msg.receiverId) {
    markAsRead(loggedInUserId, currentChatUserId);
  }

  updateInbox(msg, loggedInUserId: loggedInUserId);
});


    // typing listeners...
  }

  void updateInbox(MessageModel msg, {required int loggedInUserId}) {
  final otherUserId =
      msg.senderId == loggedInUserId ? msg.receiverId : msg.senderId;

  final existingIndex = inbox.indexWhere((m) {
    final uid = m.senderId == loggedInUserId ? m.receiverId : m.senderId;
    return uid == otherUserId;
  });

  int existingUnread = 0;
  if (existingIndex >= 0) {
    existingUnread = inbox[existingIndex].unreadCount;
    inbox.removeAt(existingIndex);
  }

  int newUnread = msg.unreadCount;

  if (msg.receiverId == loggedInUserId) {
    // if (currentChatUserId == otherUserId) {
    //   newUnread = 0;
    //   // markAsRead(loggedInUserId, otherUserId);
    // } else {
      newUnread = existingUnread + 1;
    // }
  } else {
    newUnread = existingUnread;
  }

  final msgForInbox = msg.copyWith(unreadCount: newUnread);
  inbox.insert(0, msgForInbox);

  // 👇 force reactive update
inbox.refresh();
}


Future<void> sendFile(
  int senderId,
  int receiverId,
  File file,
  String fileName,
) async {
  try {
    // 1. Upload to backend (multipart request)
    final url = Uri.parse("https://assets.ntechagent.com/ihamim_app/chat_assets");
    var request = http.MultipartRequest("POST", url);
    request.fields['senderId'] = senderId.toString();
    request.fields['receiverId'] = receiverId.toString();
    request.files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      // data["fileUrl"] -> backend returns uploaded file URL

      // 2. Emit socket event
      socket?.emit("send_message", {
        "senderId": senderId,
        "receiverId": receiverId,
        "message": fileName,
        "fileUrl": data["fileUrl"],
        "type": "file", // identify message type
      });

    } else {
      print("File upload failed: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending file: $e");
  }
}



  Future<void> markAsRead(int userId, int otherUserId) async {
    try {
      await _repository.markAsRead(userId, otherUserId);
      // best to refresh inbox from server so counts are authoritative:
      await loadInbox(userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to mark messages as read");
    }
  }

  // ... rest of the controller unchanged ...



 

// Future<void> loadConversation(int userId, int otherUserId) async {
//   try {
//     isLoading.value = true;
//     final data = await _repository.getConversation(userId, otherUserId);
//     messages.assignAll(data);

//     // Auto-scroll after assigning
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (Get.isRegistered<ScrollController>()) {
//         final scrollController = Get.find<ScrollController>();
//         if (scrollController.hasClients) {
//           scrollController.jumpTo(scrollController.position.maxScrollExtent);
//         }
//       }
//     });
//   } catch (e) {
//     Get.snackbar("Error", "Failed to load conversation");
//   } finally {
//     isLoading.value = false;
//   }
// }


// Future<void> loadInbox(int userId) async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getInbox(userId);
//       inbox.assignAll(data);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load inbox");
//     } finally {
//       isLoading.value = false;
//     }
//   }

Future<void> loadConversation(int userId, int otherUserId) async {
  try {
    isLoadingConversation.value = true;
    final data = await _repository.getConversation(userId, otherUserId);
    messages.assignAll(data);
  } finally {
    isLoadingConversation.value = false;
  }
}

Future<void> loadInbox(int userId) async {
  try {
    isLoadingInbox.value = true;
    final data = await _repository.getInbox(userId);
    inbox.assignAll(data);
  } finally {
    isLoadingInbox.value = false;
  }
}



Future<void> sendMessage(
    int senderId, int receiverId, String text, String receiverName) async {
  try {
    final user = GetStorage().read("user") ?? {};
    final senderUserName = user["name"];

    // Call API to save message in DB
    await _repository.sendMessage(
      senderId,
      receiverId,
      text,
      senderUserName,
      receiverName,
    );

    // ⚠️ Do not add it to messages here!
    // The socket 'new_message' listener will handle it
  } catch (e) {
    Get.snackbar("Error", "Failed to send message");
  }
}





  @override
  void onClose() {
    socket?.dispose(); // 👈 safe dispose
    super.onClose();
  }
}


// class MessageController extends GetxController {
//   final MessageRepository _repository;
//   IO.Socket? socket;

//   var messages = <MessageModel>[].obs;
//   var inbox = <MessageModel>[].obs;
//   var isLoading = false.obs;
//   var isOtherUserTyping = false.obs;

//   int? _loggedInUserId;


//   int currentChatUserId = -1;

//   MessageController(this._repository);

//   void setCurrentChatUser(int userId) {
//     currentChatUserId = userId;
//   }

  

//   void initSocket(int currentUserId) {
//   // save the logged in user id locally
//   _loggedInUserId = currentUserId;

//   if (socket != null && socket!.connected) return;

//   socket = IO.io(
//     "http://192.168.166.3:4000",
//     IO.OptionBuilder().setTransports(["websocket"]).enableAutoConnect().build(),
//   );

//   socket!.onConnect((_) {
//     print("Connected to socket server");
//     socket!.emit("join", currentUserId);
//   });

//   // new_message
//   socket!.off("new_message");
//   socket!.on("new_message", (data) {
//     final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
//     messages.add(msg);

//     final loggedInUserId = GetStorage().read("user")?["id"];
//     if (currentChatUserId == msg.senderId || currentChatUserId == msg.receiverId) {
//       // if I'm viewing the chat, let server handle marking read via API/socket
//       markAsRead(loggedInUserId, currentChatUserId);
//     }

//     updateInbox(msg, loggedInUserId: loggedInUserId);
//   });

//   // messages_read => someone read messages sent to them
//   socket!.off("messages_read");
//   socket!.on("messages_read", (data) {
//     // data.userId is the reader (the one who opened the chat)
//     final readerId = data["userId"] as int?;

//     if (readerId == null) return;

//     // Mark messages in local list which were sent by us to that reader as read
//     final myId = GetStorage().read("user")?["id"];
//     for (int i = 0; i < messages.length; i++) {
//       final m = messages[i];
//       // messages that I sent and receiver is readerId
//       if (m.senderId == myId && m.receiverId == readerId && !m.isRead) {
//         messages[i] = m.copyWith(isRead: true);
//       }
//     }
//     messages.refresh();

//     // Also update the inbox entry unread counts if present
//     final idx = inbox.indexWhere((m) {
//       final uid = m.senderId == myId ? m.receiverId : m.senderId;
//       return uid == readerId;
//     });
//     if (idx >= 0) {
//       final updated = inbox[idx].copyWith(unreadCount: 0);
//       inbox[idx] = updated;
//       inbox.refresh();
//     }
//   });

//   // Optional: react if someone else opened a chat with me
//   socket!.off("chat_opened");
//   socket!.on("chat_opened", (data) {
//     // data.userId = opener
//     final openerId = data["userId"] as int?;
//     if (openerId == null) return;

//     // If I'm currently viewing that chat (i.e. currentChatUserId == openerId),
//     // then I should mark messages from that user as read locally.
//     if (currentChatUserId == openerId) {
//       final myId = GetStorage().read("user")?["id"];
//       for (int i = 0; i < messages.length; i++) {
//         final m = messages[i];
//         if (m.senderId == openerId && m.receiverId == myId && !m.isRead) {
//           messages[i] = m.copyWith(isRead: true);
//         }
//       }
//       messages.refresh();
//     }
//   });

//   // typing events (keep your existing handlers)
//   socket!.off("typing");
//   socket!.on("typing", (data) {
//     if (data["senderId"] == currentChatUserId) {
//       isOtherUserTyping.value = true;
//     }
//   });

//   socket!.off("stop_typing");
//   socket!.on("stop_typing", (data) {
//     if (data["senderId"] == currentChatUserId) {
//       isOtherUserTyping.value = false;
//     }
//   });
// }


//   Future<void> markAsRead(int userId, int otherUserId) async {
//     try {
//       await _repository.markAsRead(userId, otherUserId);

//       // Update local messages to show double ticks
//       for (int i = 0; i < messages.length; i++) {
//         final msg = messages[i];
//         if (msg.senderId == otherUserId && msg.receiverId == userId && !msg.isRead) {
//           messages[i] = msg.copyWith(isRead: true); // use copyWith
//         }
//       }
//       messages.refresh();

//       // Refresh inbox from server
//       await loadInbox(userId);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to mark messages as read");
//     }
//   }

//   void updateInbox(MessageModel msg, {required int loggedInUserId}) {
//     final otherUserId = msg.senderId == loggedInUserId ? msg.receiverId : msg.senderId;
//     final existingIndex = inbox.indexWhere((m) {
//       final uid = m.senderId == loggedInUserId ? m.receiverId : m.senderId;
//       return uid == otherUserId;
//     });

//     int existingUnread = 0;
//     if (existingIndex >= 0) {
//       existingUnread = inbox[existingIndex].unreadCount;
//       inbox.removeAt(existingIndex);
//     }

//     int newUnread = msg.unreadCount;

//     if (msg.receiverId == loggedInUserId) {
//       newUnread = existingUnread + 1;
//     } else {
//       newUnread = existingUnread;
//     }

//     final msgForInbox = msg.copyWith(unreadCount: newUnread);
//     inbox.insert(0, msgForInbox);
//     inbox.refresh();
//   }


//   Future<void> sendFile(
//     int senderId,
//     int receiverId,
//     File file,
//     String fileName,
//   ) async {
//     try {
//       final url = Uri.parse("https://assets.ntechagent.com/ihamim_app/chat_assets");
//       var request = http.MultipartRequest("POST", url);
//       request.fields['senderId'] = senderId.toString();
//       request.fields['receiverId'] = receiverId.toString();
//       request.files.add(await http.MultipartFile.fromPath("file", file.path));

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         final data = jsonDecode(responseBody);

//         socket?.emit("send_message", {
//           "senderId": senderId,
//           "receiverId": receiverId,
//           "message": fileName,
//           "fileUrl": data["fileUrl"],
//           "type": "file",
//         });
//       } else {
//         print("File upload failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error sending file: $e");
//     }
//   }

  

//   Future<void> loadConversation(int userId, int otherUserId) async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getConversation(userId, otherUserId);
//       messages.assignAll(data);

//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (Get.isRegistered<ScrollController>()) {
//           final scrollController = Get.find<ScrollController>();
//           if (scrollController.hasClients) {
//             scrollController.jumpTo(scrollController.position.maxScrollExtent);
//           }
//         }
//       });
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load conversation");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadInbox(int userId) async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getInbox(userId);
//       inbox.assignAll(data);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load inbox");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> sendMessage(
//       int senderId, int receiverId, String text, String receiverName) async {
//     try {
//       final user = GetStorage().read("user") ?? {};
//       final senderUserName = user["name"];

//       await _repository.sendMessage(
//         senderId,
//         receiverId,
//         text,
//         senderUserName,
//         receiverName,
//       );
//       // socket 'new_message' listener handles adding to messages
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send message");
//     }
//   }

//   // @override
//   // void onClose() {
//   //   socket?.dispose();
//   //   super.onClose();
//   // }

//   @override
// void onClose() {
//   socket?.disconnect();
//   socket?.close();
//   super.onClose();
// }
// }
