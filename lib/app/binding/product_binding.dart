import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/data/providers/product_api.dart';
import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductApi());
    Get.lazyPut(() => ProductRepository(Get.find<ProductApi>()));
    Get.lazyPut(() => ProductController(Get.find<ProductRepository>()));
  }
}
