import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/data/models/category_model.dart';
import 'package:ihamim_multivendor/app/modules/home/widgets/productCard_widget.dart';
import 'package:ihamim_multivendor/app/modules/productDetail_screen.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

class CategoryProductsScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    // 🔹 Filter products by category
    final filteredProducts = productController.filteredProducts
        .where((p) => p.categoryName == widget.category.categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.categoryName ?? "Category", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (filteredProducts.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: ProductCard(product: product), // you can reuse your card
            );
          },
        );
      }),
    );
  }
}