import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/chat_message_controller.dart';
import 'package:ihamim_multivendor/app/data/models/chat_message_model.dart';



class ChatScreen extends StatefulWidget {
  final int currentUserId;
  final int otherUserId;
  final String otherUserName;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageController _messageController = Get.find<MessageController>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();

  _messageController.initSocket(widget.currentUserId);
  _messageController.setCurrentChatUser(widget.otherUserId);

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await _messageController.loadConversation(
      widget.currentUserId,
      widget.otherUserId,
    );

    await _messageController.markAsRead(widget.currentUserId, widget.otherUserId);
    _scrollToBottom();
  });
  

  _messageController.messages.listen((_) => _scrollToBottom());
}




  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _messageController.sendMessage(
        widget.currentUserId,
        widget.otherUserId,
        text,
        widget.otherUserName,
      );
      _textController.clear();
    }
  }

  // @override
  // void dispose() {
  //   _textController.dispose();
  //   if (Get.isRegistered<ScrollController>()) {
  //     Get.delete<ScrollController>();
  //   }
  //   super.dispose();
  // }

  @override
void dispose() {
  _textController.dispose();
  if (Get.isRegistered<ScrollController>()) {
    Get.delete<ScrollController>();
  }
  _messageController.isOtherUserTyping.value = false; // reset typing
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
  child: Column(
    children: [
      Expanded(
        child: Obx(() {
          if (_messageController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_messageController.messages.isEmpty) {
            return const Center(child: Text("No messages yet"));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: _messageController.messages.length,
            itemBuilder: (context, index) {
              final msg = _messageController.messages[index];
              final isMe = msg.senderId == widget.currentUserId;
              return _buildMessageBubble(msg, isMe);
            },
          );
        }),
      ),
      Obx(() => _messageController.isOtherUserTyping.value
          ? Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.otherUserName} is typing...",
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink()),
    ],
  ),
),

          _buildInputArea(),
        ],
      ),
    );
  }

  // Widget _buildMessageBubble(MessageModel msg, bool isMe) {
  //   return Align(
  //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
  //       decoration: BoxDecoration(
  //         color: isMe ? Colors.blueAccent : Colors.grey[300],
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             msg.message,
  //             style: TextStyle(color: isMe ? Colors.white : Colors.black87),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             _formatTime(msg.createdAt),
  //             style: TextStyle(
  //               fontSize: 10,
  //               color: isMe ? Colors.white70 : Colors.black54,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  Widget _buildMessageBubble(MessageModel msg, bool isMe) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: isMe ? Colors.blueAccent : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            msg.message,
            style: TextStyle(color: isMe ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(msg.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white70 : Colors.black54,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 6),
                Icon(
                  msg.isRead ? Icons.done_all : Icons.check,
                  size: 16,
                  color: msg.isRead
                      ? Colors.lightBlueAccent   // double tick color
                      : (isMe ? Colors.white70 : Colors.black54),
                ),
              ]
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildInputArea() {
  return SafeArea(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  _messageController.socket?.emit("typing", {
                    "senderId": widget.currentUserId,
                    "receiverId": widget.otherUserId,
                  });
                } else {
                  _messageController.socket?.emit("stop_typing", {
                    "senderId": widget.currentUserId,
                    "receiverId": widget.otherUserId,
                  });
                }
              },
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    ),
  );
}


  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }


  
}
