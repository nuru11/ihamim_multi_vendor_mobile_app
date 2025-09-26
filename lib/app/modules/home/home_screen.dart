import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/categroy_controller.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/controllers/wishlist_controller.dart';
import 'package:ihamim_multivendor/app/data/providers/category_api.dart';
import 'package:ihamim_multivendor/app/data/providers/product_api.dart';
import 'package:ihamim_multivendor/app/data/repositories/categroy_repository.dart';
import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';
import 'package:ihamim_multivendor/app/modules/categoryProduct_screen.dart';
import 'package:ihamim_multivendor/app/modules/home/widgets/categoryList_widget.dart';
import 'package:ihamim_multivendor/app/modules/home/widgets/filter_bottom_sheet.dart';
import 'package:ihamim_multivendor/app/modules/home/widgets/productCard_widget.dart';
import 'package:ihamim_multivendor/app/modules/productDetail_screen.dart';
import 'package:ihamim_multivendor/app/modules/wishlist_screen.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductController productController;
  late final CategoryController categoryController;
  final wishlistController = Get.find<WishlistController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productController =
        Get.put(ProductController(ProductRepository(ProductApi())));
    categoryController =
        Get.put(CategoryController(CategoryRepository(CategoryApi())));

    // fetch initial data
    productController.getAllProductsController();
    categoryController.getAllCategoryController();

    // Listen to GetX searchQuery changes and update TextField
    ever(productController.searchQuery, (value) {
      searchController.text = value;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length),
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await productController.getAllProductsController();
            await categoryController.getAllCategoryController();
          },
          child: CustomScrollView(
            slivers: [
              // 🔹 Sticky Top Section
              SliverPersistentHeader(
  pinned: true,
  floating: false,
  delegate: _StickyHeaderDelegate(
    minHeight: 120 + MediaQuery.of(context).padding.top, // add top padding
    maxHeight: 160 + MediaQuery.of(context).padding.top,
    child: Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12 + MediaQuery.of(context).padding.top, // top padding for status bar
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location + notifications row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "Addis Ababa",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search bar
          SizedBox(
            height: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (val) => productController.searchQuery.value = val,
                      decoration: const InputDecoration(
                        hintText: "Search products...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showFilterBottomSheet(
                        context,
                        productController,
                        categoryController,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),


              // 🔹 Category List
              SliverToBoxAdapter(
                child: CategoryListWidget(categoryController: categoryController),
              ),

              // 🔹 Products Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = productController.filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                    childCount: productController.filteredProducts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              ),

              // 🔹 Add products button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WishlistScreen()),
                      );
                    },
                    child: const Text('Add Products'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showFilterBottomSheet(
      BuildContext context,
      ProductController productController,
      CategoryController categoryController,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FilterBottomSheet(
        productController: productController,
        categoryController: categoryController,
      ),
    );
  }
}

// 🔹 Sticky Header Delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}



///////////////////////////////////////////////////////



// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late final ProductController productController;
//   late final CategoryController categoryController;
//   final wishlistController = Get.find<WishlistController>();

//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     productController =
//         Get.put(ProductController(ProductRepository(ProductApi())));
//     categoryController =
//         Get.put(CategoryController(CategoryRepository(CategoryApi())));

//     // fetch initial data
//     productController.getAllProductsController();
//     categoryController.getAllCategoryController();

//     // Listen to GetX searchQuery changes and update TextField
//     ever(productController.searchQuery, (value) {
//       searchController.text = value;
//       // Move cursor to the end
//       searchController.selection = TextSelection.fromPosition(
//         TextPosition(offset: searchController.text.length),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     String getFirstImage(String gallery) {
//       if (gallery.isEmpty) return "https://via.placeholder.com/150";
//       final parts = gallery.split(",");
//       return parts.first.trim();
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Obx(() {
//         return RefreshIndicator(
//           onRefresh: () async {
//             await productController.getAllProductsController();
//             await categoryController.getAllCategoryController();
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔹 Top Section
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
//                   decoration: BoxDecoration(
//                     color: mainColor,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Row: Location + Bell
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: const [
//                               Icon(Icons.location_on,
//                                   color: Colors.white, size: 20),
//                               SizedBox(width: 5),
//                               Text(
//                                 "Addis Ababa",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Icon(Icons.arrow_drop_down, color: Colors.white),
//                             ],
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white24,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(Icons.notifications,
//                                 color: Colors.white, size: 20),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

                     
// // 🔹 Search Field with Suggestions
// Container(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(12),
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           const Icon(Icons.search, color: Colors.grey),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: searchController, // TextEditingController
//               onChanged: (val) => productController.searchQuery.value = val,
//               decoration: const InputDecoration(
//                 hintText: "Search products...",
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           GestureDetector(
//   onTap: () {
//     showFilterBottomSheet(context, productController, categoryController);
//   },
//   child: Container(
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: mainColor,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
//   ),
// ),
//         ],
//       ),

//       // 🔹 Suggestions Box
//       Obx(() {
//         if (productController.suggestions.isEmpty) return const SizedBox.shrink();
//         return Container(
//           margin: const EdgeInsets.only(top: 4),
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ListView(
//             shrinkWrap: true,
//             children: productController.suggestions.map((s) {
//               return GestureDetector(
//                 onTap: () {
//                   // ✅ Set the suggestion in the search field
//                   productController.searchQuery.value = s;
//                   productController.suggestions.clear();
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6),
//                   child: Text(
//                     s,
//                     style: TextStyle(
//                       color: mainColor,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       }),
//     ],
//   ),
// )


//                     ],
//                   ),
//                 ),

//                 // ✅ Category List
//                 CategoryListWidget(categoryController: categoryController),

//                 // ✅ Products Grid
//                 GridView.builder(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   physics: const NeverScrollableScrollPhysics(),
//   shrinkWrap: true,
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 12,
//     mainAxisSpacing: 12,
//     childAspectRatio: 0.72,
//   ),
//   itemCount: productController.filteredProducts.length,
//   itemBuilder: (context, index) {
//     final product = productController.filteredProducts[index];

//     return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => ProductDetailScreen(product: product),
//                   ),
//                 );
//               },
//               child: ProductCard(product: product), // you can reuse your card
//             );
//   },
// ),
//                 const SizedBox(height: 16),

//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           // builder: (context) => AddproductScreen()
//                           builder: (context) => WishlistScreen()
//                           ),
//                     );
//                   },
//                   child: const Text('Add Products'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }


// void showFilterBottomSheet(
//   BuildContext context,
//   ProductController productController,
//   CategoryController categoryController,
// ) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//     ),
//     builder: (_) => FilterBottomSheet(
//       productController: productController,
//       categoryController: categoryController,
//     ),
//   );
// }

  
// }