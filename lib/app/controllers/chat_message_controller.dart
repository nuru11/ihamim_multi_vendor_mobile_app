import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import '../data/models/chat_message_model.dart';
import '../data/repositories/message_repository.dart';

// class MessageController extends GetxController {
//   final MessageRepository _repository;
//   IO.Socket? socket;
//   var messages = <MessageModel>[].obs;
//   var inbox = <MessageModel>[].obs;
//   var isLoading = false.obs;
//   var isOtherUserTyping = false.obs;
//   late int currentChatUserId;

//   MessageController(this._repository);

//   void setCurrentChatUser(int userId) {
//     currentChatUserId = userId;
//   }

//   void initSocket(int userId) {
//     if (socket != null && socket!.connected) return;
//     socket = IO.io(
//       "http://192.168.1.7:4000",
//       IO.OptionBuilder()
//           .setTransports(["websocket"])
//           .enableAutoConnect()
//           .build(),
//     );
//     socket!.onConnect((_) {
//       print("Connected to socket server");
//       socket!.emit("join", userId);
//     });
//     socket!.off("new_message");
//     socket!.on("new_message", (data) {
//       final msg = MessageModel.fromJson(data);
//       messages.add(msg);
//     });
//     socket!.off("typing");
//     socket!.on("typing", (data) {
//       if (data["senderId"] == currentChatUserId) {
//         isOtherUserTyping.value = true;
//       }
//     });
//     socket!.off("stop_typing");
//     socket!.on("stop_typing", (data) {
//       if (data["senderId"] == currentChatUserId) {
//         isOtherUserTyping.value = false;
//       }
//     });
//     socket!.onDisconnect((_) => print("Socket disconnected"));
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

//   Future<void> sendMessage(int senderId, int receiverId, String text, String receiverName) async {
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
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send message");
//     }
//   }

//   @override
//   void onClose() {
//     socket?.dispose();
//     super.onClose();
//   }
// }


class MessageController extends GetxController {
  final MessageRepository _repository;
  IO.Socket? socket;

  var messages = <MessageModel>[].obs;
  var inbox = <MessageModel>[].obs;
  var isLoading = false.obs;
  var isOtherUserTyping = false.obs;

  // default to -1 (no chat open)
  int currentChatUserId = -1;

  MessageController(this._repository);

  void setCurrentChatUser(int userId) {
    currentChatUserId = userId;
  }

  void initSocket(int userId) {
    if (socket != null && socket!.connected) return;

    socket = IO.io(
      "http://192.168.166.3:4000",
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



 

Future<void> loadConversation(int userId, int otherUserId) async {
  try {
    isLoading.value = true;
    final data = await _repository.getConversation(userId, otherUserId);
    messages.assignAll(data);

    // Auto-scroll after assigning
    Future.delayed(const Duration(milliseconds: 300), () {
      if (Get.isRegistered<ScrollController>()) {
        final scrollController = Get.find<ScrollController>();
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      }
    });
  } catch (e) {
    Get.snackbar("Error", "Failed to load conversation");
  } finally {
    isLoading.value = false;
  }
}


Future<void> loadInbox(int userId) async {
    try {
      isLoading.value = true;
      final data = await _repository.getInbox(userId);
      inbox.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load inbox");
    } finally {
      isLoading.value = false;
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
