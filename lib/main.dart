import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/controllers/chat_message_controller.dart';
import 'package:ihamim_multivendor/app/controllers/wishlist_controller.dart';
import 'package:ihamim_multivendor/app/data/providers/chats/chat_api.dart';
import 'package:ihamim_multivendor/app/data/repositories/message_repository.dart';
import 'package:ihamim_multivendor/app/services/storage_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  Get.put(MessageApi());
  Get.put(MessageRepository(Get.find<MessageApi>()));
  Get.put(MessageController(Get.find<MessageRepository>()));

  Get.put(WishlistController());

  // Register StorageService globally
  Get.put(StorageService(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.MAINSCREEN,
      getPages: AppPages.pages,
    );
  }
}
