import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/services/storage_service.dart';
import '../controllers/auth_controller.dart';
import '../data/providers/auth_api.dart';
import '../data/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthApi());
    Get.lazyPut(() => AuthRepository(Get.find<AuthApi>(), Get.find<StorageService>()));
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()));
  }
}
