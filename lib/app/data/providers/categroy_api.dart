import 'package:dio/dio.dart';
import 'package:ihamim_multivendor/app/data/models/category_model.dart';
import 'package:ihamim_multivendor/app/utils/constants/api_endpoint.dart';

class CategoryApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiEndpoints.baseUrl),
  );

  Future<List<CategoryModel>> getCategoryApi() async {
    print("Get All Categories called ${ApiEndpoints.getAllCategories}");
    try {
      final response = await _dio.get(ApiEndpoints.getAllCategories);

      final data = response.data;
      print("Get All Categories response data: $data");

      // Assuming your API returns a JSON array: [ {id:1,...}, {id:2,...} ]
      return (data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
