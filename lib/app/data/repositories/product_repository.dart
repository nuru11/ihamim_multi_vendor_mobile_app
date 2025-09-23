import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/data/providers/auth_api.dart';
import 'package:ihamim_multivendor/app/data/providers/product_api.dart';

class ProductRepository {
  final ProductApi _productApi;

  ProductRepository(this._productApi);

  Future<List<ProductModel>> getAllProductRepository() async {
    return await _productApi.getProductApi();
  }
}
