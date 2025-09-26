import 'package:ihamim_multivendor/app/data/models/category_model.dart';
import 'package:ihamim_multivendor/app/data/providers/category_api.dart';

class CategoryRepository {
  final CategoryApi _categoryApi;

  CategoryRepository(this._categoryApi);

  Future<List<CategoryModel>> getAllCategoryRepository() async {
    return await _categoryApi.getCategoryApi();
  }
}
