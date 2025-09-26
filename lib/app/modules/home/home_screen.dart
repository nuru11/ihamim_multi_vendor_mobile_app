import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/categroy_controller.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/controllers/wishlist_controller.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/data/providers/categroy_api.dart';
import 'package:ihamim_multivendor/app/data/providers/product_api.dart';
import 'package:ihamim_multivendor/app/data/repositories/categroy_repository.dart';
import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';
import 'package:ihamim_multivendor/app/modules/addProduct_screen.dart';
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
      // Move cursor to the end
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
    String getFirstImage(String gallery) {
      if (gallery.isEmpty) return "https://via.placeholder.com/150";
      final parts = gallery.split(",");
      return parts.first.trim();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await productController.getAllProductsController();
            await categoryController.getAllCategoryController();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Top Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row: Location + Bell
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 20),
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
                            child: const Icon(Icons.notifications,
                                color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ✅ Search Bar (single clean version)
                      // ✅ Search Bar with Suggestions
// 🔹 Search Field with Suggestions
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController, // TextEditingController
              onChanged: (val) => productController.searchQuery.value = val,
              decoration: const InputDecoration(
                hintText: "Search products...",
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showFilterBottomSheet(context);
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

      // 🔹 Suggestions Box
      Obx(() {
        if (productController.suggestions.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: productController.suggestions.map((s) {
              return GestureDetector(
                onTap: () {
                  // ✅ Set the suggestion in the search field
                  productController.searchQuery.value = s;
                  productController.suggestions.clear();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    s,
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    ],
  ),
)


                    ],
                  ),
                ),

                // ✅ Category List
                SizedBox(
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
                        final category =
                            categoryController.categories[index];
                        return Container(
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
                                  category.categoryImage ??
                                      "https://via.placeholder.com/60",
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error,
                                          color: Colors.red),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                category.categoryName ?? "Unknown",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),

                // ✅ Products Grid
                GridView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  physics: const NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.72,
  ),
  itemCount: productController.filteredProducts.length,
  itemBuilder: (context, index) {
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
            // 🔹 Product Image + Badges
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
            Padding(
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
                  const SizedBox(height: 4),
                  Text(
                    "ETB ${product.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.carModel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          // builder: (context) => AddproductScreen()
                          builder: (context) => WishlistScreen()
                          ),
                    );
                  },
                  child: const Text('Add Products'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }




  void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Obx(() {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const Text(
                  "Filter Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // 🔹 Price Range
                const Text("Price Range", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Min",
                          prefixText: "ETB ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          productController.minPrice.value = double.tryParse(val) ?? 0;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Max",
                          prefixText: "ETB ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          productController.maxPrice.value = double.tryParse(val) ?? 1000000;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Category
                const Text("Category", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text("Select Category"),
                    value: productController.selectedCategory.value,
                    items: categoryController.categories
                        .map((cat) => DropdownMenuItem(
                              value: cat.categoryName,
                              child: Text(cat.categoryName ?? "Unknown"),
                            ))
                        .toList(),
                    onChanged: (val) => productController.selectedCategory.value = val,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Condition
                const Text("Condition", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text("Choose Condition"),
                    value: productController.condition.value,
                    items: ["new", "used"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => productController.condition.value = val,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Sort
                const Text("Sort By", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: productController.sortBy.value,
                    items: const [
                      DropdownMenuItem(value: "popular", child: Text("Popular")),
                      DropdownMenuItem(value: "urgent", child: Text("Urgent")),
                      DropdownMenuItem(value: "high", child: Text("Price: High to Low")),
                      DropdownMenuItem(value: "low", child: Text("Price: Low to High")),
                    ],
                    onChanged: (val) => productController.sortBy.value = val ?? "popular",
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Reset filters
                          productController.selectedCategory.value = null;
                          productController.condition.value = null;
                          productController.minPrice.value = 0;
                          productController.maxPrice.value = 1000000;
                          productController.sortBy.value = "popular";
                          productController.applyFilters(); // ✅ apply after reset
                          Navigator.pop(context);
                        },
                        child: const Text("Clear Filters"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: mainColor,
                        ),
                        onPressed: () {
                          productController.applyFilters(); // ✅ apply filters
                          Navigator.pop(context);
                        },
                        child: const Text("Apply Filters",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}


}




class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  String getFirstImage(String gallery) {
    if (gallery.isEmpty) return "https://via.placeholder.com/150";
    return gallery.split(",").first.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.productName, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share logic here
            },
          ),

          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Favorite logic here
            },
          ),
         ],
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80), // Leave space for buttons
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            SizedBox(
              height: 250,
              child: PageView(
                children: product.productGallery
                    .split(",")
                    .map((img) => Image.network(
                          img.trim(),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.network("https://via.placeholder.com/150"),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Product Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("ETB ${product.price}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 12),
                  Text(product.productDescription,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 20),
                  Text("Model: ${product.carModel}",
                      style: const TextStyle(fontSize: 14)),
                  Text("Condition: ${product.carCondition}",
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // Fixed Bottom Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Buy now logic
                },
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: Row(children: [
                   const Text("Call Now", style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 8),
                    const Icon(Icons.call, color: Colors.white), // Call icon
                   ]
                   ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
  child: OutlinedButton(
    onPressed: () {
      // Chat logic
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Color(0xFF38A001), width: 2), // Set border color and width
    ),
    child: Row(children: [ 
      Text("Chat Seller", style: TextStyle(color: mainColor, fontSize: 16)),
      const SizedBox(width: 8),
      Icon(Icons.chat, color: mainColor), // Chat icon
      ]),
  ),
),
          ],
        ),
      ),
    );
  }
}








////////////////////////////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
// import 'package:ihamim_multivendor/app/data/models/product_model.dart';
// import 'package:ihamim_multivendor/app/data/providers/product_api.dart';
// import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';
// import 'package:ihamim_multivendor/app/modules/addProduct_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late final ProductController productController;
//   final ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     productController =
//         Get.put(ProductController(ProductRepository(ProductApi())));

//    scrollController.addListener(() {
//   if (scrollController.position.pixels >=
//       scrollController.position.maxScrollExtent &&
//       productController.hasMore.value &&
//       !productController.isLoading.value) {
//     productController.getProducts(loadMore: true);
//   }
// });

//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   String getFirstImage(String gallery) {
//     if (gallery.isEmpty) return "https://via.placeholder.com/150";
//     return gallery.split(",").first.trim();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Obx(() {
//         return SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔹 Top Section
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
//                 decoration: const BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Location + Notifications
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: const [
//                             Icon(Icons.location_on, color: Colors.white, size: 20),
//                             SizedBox(width: 5),
//                             Text("Addis Ababa",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600)),
//                             Icon(Icons.arrow_drop_down, color: Colors.white),
//                           ],
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                               color: Colors.white24,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: const Icon(Icons.notifications,
//                               color: Colors.white, size: 20),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // Search Bar
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.search, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           const Expanded(
//                             child: TextField(
//                               decoration: InputDecoration(
//                                   hintText: "Search", border: InputBorder.none),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(Icons.filter_list,
//                                 color: Colors.white, size: 20),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Grid of products
//               GridView.builder(
//                 controller: scrollController,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.7,
//                 ),
//                 itemCount: productController.products.length +
//                     (productController.hasMore.value ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index < productController.products.length) {
//                     final product = productController.products[index];
//                     return ProductCard(product: product);
//                   } else {
//                     // Loader at the bottom
//                     return const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                 },
//               ),

//               const SizedBox(height: 16),

//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AddproductScreen()));
//                 },
//                 child: const Text('Add Products'),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }



// class ProductCard extends StatelessWidget {
//   final ProductModel product;
//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // product image
//           Expanded(
//             child: ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//               child: Image.network(
//                 product.productGallery.isNotEmpty
//                     ? product.productGallery.split(",").first
//                     : "http://assets.ntechagent.com/ihamim_app/1.jpeg",
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),
//           ),

//           // product name
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               product.productName ?? "No name",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),

//           // product price
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               "\$${product.price ?? "0"}",
//               style: const TextStyle(color: Colors.green),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
