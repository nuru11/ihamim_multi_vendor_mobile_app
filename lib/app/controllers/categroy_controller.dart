import 'package:get/state_manager.dart';
import 'package:ihamim_multivendor/app/data/models/category_model.dart';
import 'package:ihamim_multivendor/app/data/repositories/categroy_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository;
  CategoryController(this._repository);

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
void onReady() {
  super.onReady();
  getAllCategoryController();
}


  Future<void> getAllCategoryController() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _repository.getAllCategoryRepository();
      categories.value = fetchedCategories;
    } finally {
      isLoading.value = false;
    }
  }
}