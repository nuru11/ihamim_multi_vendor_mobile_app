import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/controllers/wishlist_controller.dart';
import 'package:ihamim_multivendor/app/modules/home/home_screen.dart';
import 'package:ihamim_multivendor/app/modules/productDetail_screen.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';



class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final productController = Get.find<ProductController>();

    String getFirstImage(String gallery) {
      if (gallery.isEmpty) return "https://via.placeholder.com/150";
      final parts = gallery.split(",");
      return parts.first.trim();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: Obx(() {
        // Filter products that are in wishlist
        final wishlistProducts = productController.filteredProducts
            .where((p) => wishlistController.isInWishlist(p.id))
            .toList();

        if (wishlistProducts.isEmpty) {
          return const Center(
            child: Text(
              "No items in wishlist",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: wishlistProducts.length,
          itemBuilder: (context, index) {
            final product = wishlistProducts[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Image
                    Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  getFirstImage(product.productGallery),
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "http://assets.ntechagent.com/ihamim_app/1.jpeg",
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              // 🔹 Car Condition Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.carCondition.toLowerCase() == "new"
                        ? Colors.green.withOpacity(0.9)
                        : Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.carCondition.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 🔹 Wishlist Button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => wishlistController.toggleWishlist(product.id),
                  child: Obx(() {
                    final isWished = wishlistController.isInWishlist(product.id);
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: Icon(
                        isWished ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isWished ? Colors.red : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

                    // 🔹 Info Section
                    Expanded(
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        // const SizedBox(height: 4),
        Text(
          "ETB ${product.price}",
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: mainColor,
          ),
        ),
        // const SizedBox(height: 6),
        Text(
          product.carModel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        // const SizedBox(height: 4),
  
        // 🔹 City
        Text(
          product.city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey[600],
          ),
        ),
  
        // 🔹 Category Name
        Text(
          product.categoryName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  ),
),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
