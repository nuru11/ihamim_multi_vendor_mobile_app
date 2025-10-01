import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/chat_message_controller.dart';
import 'package:ihamim_multivendor/app/data/providers/chats/chat_api.dart';
import 'package:ihamim_multivendor/app/data/repositories/message_repository.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageApi>(() => MessageApi());
    Get.lazyPut<MessageRepository>(() => MessageRepository(Get.find<MessageApi>()));
    Get.lazyPut<MessageController>(() => MessageController(Get.find<MessageRepository>()));
  }
}
