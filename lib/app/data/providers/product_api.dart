
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/data/models/vendor_model.dart';
import 'package:ihamim_multivendor/app/utils/constants/api_endpoint.dart';
import 'package:ihamim_multivendor/app/data/models/user_model.dart';

// class ProductApi {
//   final Dio _dio = Dio(
//     BaseOptions(baseUrl: ApiEndpoints.baseUrl), // use base url
//   );



//   Future<ProductModel> getProductApi() async {
//     print("Get All Products called ${ApiEndpoints.getAllProducts}");
//     try {
//       final response = await _dio.get(
//         ApiEndpoints.getAllProducts,
        
//       );

//       final data = response.data;
//       print("Get All Product response data: $data");
//       final productData = data;

//       return ProductModel.fromJson(productData);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }



class ProductApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiEndpoints.baseUrl),
  );

  Future<List<ProductModel>> getProductApi() async {
    print("Get All Products called ${ApiEndpoints.getAllProducts}");
    try {
      final response = await _dio.get(ApiEndpoints.getAllProducts);

      final data = response.data;
      print("Get All Product response data: $data");

      // Assuming your API returns a JSON array: [ {id:1,...}, {id:2,...} ]
      return (data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
