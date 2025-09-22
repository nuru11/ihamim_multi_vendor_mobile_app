import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/services/storage_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();

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
      initialRoute: Routes.HOME,
      getPages: AppPages.pages,
    );
  }
}
