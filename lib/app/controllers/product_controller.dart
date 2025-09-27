import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/data/models/user_model.dart';
import 'package:ihamim_multivendor/app/data/models/vendor_model.dart';
import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';
import 'package:string_similarity/string_similarity.dart';

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
  var filteredProducts = <ProductModel>[].obs;
  var filteredProductsForCategory = <ProductModel>[].obs;

  // 🔹 Loading state
  var isLoading = false.obs;

  // 🔹 Search
  var searchQuery = "".obs;
  var suggestions = <String>[].obs;

  // 🔹 Filters
  var minPrice = 0.0.obs;
  var maxPrice = 100000000000000.0.obs;
  var selectedCategory = RxnString();
  var condition = RxnString(); // "new" or "used"
  var sortBy = "popular".obs;

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery, (_) => applyFilters()); 
    everAll([minPrice, maxPrice, selectedCategory, condition, sortBy],
        (_) => applyFilters());
    getAllProductsController(); // fetch products on init
  }

  Future<void> getAllProductsController() async {
    try {
      isLoading.value = true; // start loading
      final fetched = await _repository.getAllProductRepository();
      products.assignAll(fetched);
      filteredProducts.assignAll(fetched);
      filteredProductsForCategory.assignAll(fetched);
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false; // stop loading
    }
  }

  void applyFilters() {
    final query = searchQuery.value.toLowerCase();
    List<ProductModel> temp = products;

    // 🔹 Search filter
    if (query.isNotEmpty) {
      temp = temp.where((p) {
        final name = p.productName.toLowerCase();
        final desc = p.productDescription?.toLowerCase() ?? "";
        final model = p.carModel?.toLowerCase() ?? "";
        return name.contains(query) ||
            desc.contains(query) ||
            model.contains(query);
      }).toList();
    }

    // 🔹 Category filter
    if (selectedCategory.value != null && selectedCategory.value!.isNotEmpty) {
      print("Filtering by category: ${selectedCategory.value}");
      temp = temp.where((p) => p.categoryName.toLowerCase() == selectedCategory.value!.toLowerCase()).toList();
    }

    // 🔹 Condition filter
    if (condition.value != null && condition.value!.isNotEmpty) {
      temp = temp.where((p) =>
          p.carCondition.toLowerCase() == condition.value!.toLowerCase()).toList();
    }

    // 🔹 Price filter
    temp = temp
        .where((p) =>
            (p.price ?? 0) >= minPrice.value &&
            (p.price ?? 0) <= maxPrice.value)
        .toList();

    // 🔹 Sorting
    switch (sortBy.value) {
      case "high":
        temp.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case "low":
        temp.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
    }

    filteredProducts.assignAll(temp);

    // 🔹 Suggestions
    suggestions.assignAll(
      temp
          .where((p) => query.isNotEmpty)
          .map((p) => p.productName)
          .take(5)
          .toList(),
    );
  }
}
