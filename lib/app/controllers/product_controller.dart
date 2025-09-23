import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/data/models/user_model.dart';
import 'package:ihamim_multivendor/app/data/models/vendor_model.dart';
import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';

// class ProductController extends GetxController {
//   final ProductRepository _repository;

//   ProductController(this._repository);

//   var user = Rx<UserModel?>(null);
//   var vendor = Rx<VendorModel?>(null);
//   var isLoading = false.obs;

//   @override
// void onReady() {
//   super.onReady();
//   // _loadUser();
// }

// // Future<void> _loadUser() async {
// //   user.value = await _repository.getSavedUser();
// // }

//   Future<void> getAllProductsController() async {
//     try {
//       isLoading.value = true;
//       final products = await _repository.getAllProductRepository();
//       print("Fetched products: $products");
//     } catch (e) {
//       Get.snackbar("Products Error", e.toString());
//       print("Error fetching products: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

// //   Future<void> getSingleVendorController(String token) async {
// //     print("Fetching vendor with token: $token");
// //   try {
// //     isLoading.value = true;
// //     final vendorData = await _repository.getSingleVendorRepository(token);
// //     print("Fetched vendor: $vendorData");
// //     vendor.value = vendorData;   // assign to the Rx<VendorModel?>
// //   } catch (e) {
// //     Get.snackbar("Vendor Error", e.toString());
// //     print("Error fetching vendor: $e");
// //   } finally {
// //     isLoading.value = false;
// //   }
// // }


 
// }



class ProductController extends GetxController {
  final ProductRepository _repository;
  ProductController(this._repository);

  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
void onReady() {
  super.onReady();
  getAllProductsController();
}


  Future<void> getAllProductsController() async {
    try {
      isLoading.value = true;
      final fetchedProducts = await _repository.getAllProductRepository();
      products.value = fetchedProducts;
    } finally {
      isLoading.value = false;
    }
  }
}
