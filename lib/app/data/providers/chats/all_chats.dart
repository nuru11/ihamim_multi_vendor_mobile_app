import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/controllers/chat_message_controller.dart';
import 'package:ihamim_multivendor/app/modules/chat_screen.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final box = GetStorage();
  final MessageController _messageController = Get.find<MessageController>();
  late int currentUserId;

  // Reactive unread counts
  final RxMap<int, int> unreadCounts = <int, int>{}.obs;

  @override
void initState() {
  super.initState();

  final user = box.read("user") ?? {};
  currentUserId = user["id"];

  // Load inbox initially
  _messageController.loadInbox(currentUserId);

  _messageController.initSocket(currentUserId);
  
}


  
  void _openChat(int otherUserId) async {
  // Reset local unread
  unreadCounts[otherUserId] = 0;

  // Call backend to mark as read
  await _messageController.markAsRead(currentUserId, otherUserId);

  // Navigate
  Get.to(() => ChatScreen(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        otherUserName: "User $otherUserId",
      ));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: Obx(() {
        if (_messageController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final inbox = _messageController.inbox;

        if (inbox.isEmpty) {
          return const Center(child: Text("No chats yet"));
        }

        return ListView.builder(
          itemCount: inbox.length,
          itemBuilder: (context, index) {
            final msg = inbox[index];
            final otherUserId =
                msg.senderId == currentUserId ? msg.receiverId : msg.senderId;
            final otherUserName =
                msg.senderId == currentUserId ? msg.receiverName : msg.senderName;

            // final unread = unreadCounts[otherUserId] ?? 0;
            final unread = msg.unreadCount;


            return ListTile(
             

              onTap: () async {
  // set the active chat in controller
  _messageController.setCurrentChatUser(otherUserId);

  // mark messages as read on server & refresh inbox
  await _messageController.markAsRead(currentUserId, otherUserId);

  // navigate
  Get.to(() => ChatScreen(
    currentUserId: currentUserId,
    otherUserId: otherUserId,
    otherUserName: otherUserName,
  ));
},

              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(
                  "U$otherUserId",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(otherUserName),
              subtitle: Text(
                msg.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(msg.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$unread",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ]
                ],
              ),
            );
          },
        );
      }),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}



/////////////////////////////////////////////////////////
///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:ihamim_multivendor/app/controllers/chat_message_controller.dart';
// import 'package:ihamim_multivendor/app/data/models/chat_message_model.dart';
// import 'package:ihamim_multivendor/app/modules/chat_screen.dart';
// import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   final box = GetStorage();
//   final MessageController _messageController = Get.find<MessageController>();
//   late int currentUserId;

//   // Make unreadCounts reactive
//   final RxMap<int, int> unreadCounts = <int, int>{}.obs;

//   @override
//   void initState() {
//     super.initState();

//     final user = box.read("user") ?? {};
//     currentUserId = user["id"];

//     // Load inbox initially
//     _messageController.loadInbox(currentUserId);

//     // Listen for new messages via socket
//     _messageController.socket?.on("new_message", (data) {
//       final msg = MessageModel.fromJson(data);

//       // Only update inbox if this user is involved
//       if (msg.senderId == currentUserId || msg.receiverId == currentUserId) {
//         _updateInbox(msg);

//         // If the current user is the receiver, increase unread count
//         if (msg.receiverId == currentUserId) {
//           final otherUserId = msg.senderId;
//           unreadCounts[otherUserId] = (unreadCounts[otherUserId] ?? 0) + 1;
//         }
//       }
//     });
//   }

//   void _updateInbox(MessageModel msg) {
//     // Remove old chat if exists
//     _messageController.inbox.removeWhere((m) =>
//         (m.senderId == msg.senderId && m.receiverId == msg.receiverId) ||
//         (m.senderId == msg.receiverId && m.receiverId == msg.senderId));

//     // Add new message
//     _messageController.inbox.add(msg);

//     // Sort by latest message
//     _messageController.inbox.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//   }

//   void _openChat(int otherUserId) {
//     // Reset unread count for this chat
//     unreadCounts[otherUserId] = 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chats", style: TextStyle(color: Colors.white)),
//         backgroundColor: mainColor,
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (_messageController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final inbox = _messageController.inbox;

//         if (inbox.isEmpty) {
//           return const Center(child: Text("No chats yet"));
//         }

//         return ListView.builder(
//           itemCount: inbox.length,
//           itemBuilder: (context, index) {
//             final msg = inbox[index];
//             final otherUserId =
//                 msg.senderId == currentUserId ? msg.receiverId : msg.senderId;
//             final otherUserName =
//                 msg.senderId == currentUserId ? msg.receiverName : msg.senderName;

//             final unread = unreadCounts[otherUserId] ?? 0;

//             return ListTile(
//               onTap: () {
//                 _openChat(otherUserId); // Reset unread count
//                 Get.to(() => ChatScreen(
//                       currentUserId: currentUserId,
//                       otherUserId: otherUserId,
//                       otherUserName: otherUserName,
//                     ));
//               },
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[300],
//                 child: Text(
//                   "U$otherUserId",
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//               title: Text(otherUserName),
//               subtitle: Text(
//                 msg.message,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     _formatTime(msg.createdAt),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   if (unread > 0) ...[
//                     const SizedBox(width: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         "$unread",
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                     )
//                   ]
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }

//   String _formatTime(DateTime time) {
//     return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
//   }
// }
