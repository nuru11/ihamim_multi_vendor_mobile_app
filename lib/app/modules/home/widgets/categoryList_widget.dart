// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ihamim_multivendor/app/controllers/categroy_controller.dart';
// import 'package:ihamim_multivendor/app/modules/categoryProduct_screen.dart';


// class CategoryListWidget extends StatelessWidget {
//   final CategoryController categoryController;

//   const CategoryListWidget({super.key, required this.categoryController});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: Obx(() {
//         if (categoryController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (categoryController.categories.isEmpty) {
//           return const Center(child: Text("No categories found"));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           scrollDirection: Axis.horizontal,
//           itemCount: categoryController.categories.length,
//           itemBuilder: (context, index) {
//             final category = categoryController.categories[index];
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CategoryProductsScreen(category: category),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: const EdgeInsets.only(right: 12),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 60,
//                       width: 60,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Image.network(
//                         "http://assets.ntechagent.com/ihamim_app/category/1.png",
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Icon(Icons.error, color: Colors.red),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       category.categoryName ?? "Unknown",
//                       style: const TextStyle(
//                           fontSize: 12, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/categroy_controller.dart';
import 'package:ihamim_multivendor/app/modules/categoryProduct_screen.dart';

class CategoryListWidget extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryListWidget({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    // List of category images (index 0 => category 1, etc.)
    final List<String> categoryImages = List.generate(
      9,
      (index) => "http://assets.ntechagent.com/ihamim_app/category/${index + 1}.png",
    );

    return SizedBox(
      height: 100,
      child: Obx(() {
        if (categoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: categoryController.categories.length,
          itemBuilder: (context, index) {
            final category = categoryController.categories[index];
            final imageUrl = index < categoryImages.length
                ? categoryImages[index]
                : categoryImages.last; // fallback if more categories

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(category: category),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category.categoryName ?? "Unknown",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
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
