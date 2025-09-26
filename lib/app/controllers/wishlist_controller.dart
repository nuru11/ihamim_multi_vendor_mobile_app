import 'package:get/get.dart';

class WishlistController extends GetxController {
  // Dummy wishlist data (store product IDs)
  var wishlist = <int>{}.obs;

  void toggleWishlist(int productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }
  }

  bool isInWishlist(int productId) {
    return wishlist.contains(productId);
  }
}
