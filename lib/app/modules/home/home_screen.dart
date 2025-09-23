import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/data/providers/product_api.dart';
import 'package:ihamim_multivendor/app/data/repositories/product_repository.dart';
import 'package:ihamim_multivendor/app/modules/addProduct_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final ProductController productController;
  @override
  void initState() {
    super.initState();
    productController = Get.put(ProductController(ProductRepository(ProductApi())));
    productController.getAllProductsController();
  }
  
  @override
  Widget build(BuildContext context) {

    final productController =
        Get.put(ProductController(ProductRepository(ProductApi())));


        String getFirstImage(String gallery) {
  if (gallery.isEmpty) return "https://via.placeholder.com/150"; // fallback
  final parts = gallery.split(",");
  final firstPath = parts.first.trim();
  // If your API already returns relative paths, prefix with your base URL:
  return firstPath;
}

        
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return SingleChildScrollView(  // ✅ Makes it scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                decoration: const BoxDecoration(
                  color: Colors.blue, // Red background
                  borderRadius: BorderRadius.only(
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
                          child: const Icon(Icons.notifications,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
        
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.filter_list,
                                color: Colors.white, size: 20),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
             
        
              
             SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
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
                          child: Image.network("http://assets.ntechagent.com/ihamim_app/toyota.png", fit: BoxFit.contain),
                        ),
                       
                      ],
                    ),
                  );
                },
              ),
            ),
        
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const NeverScrollableScrollPhysics(), // prevent nested scroll
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  final product = productController.products[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
//                          ClipRRect(
//   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//   child: Image.network(
//     getFirstImage(product.productGallery),
//     height: 120,
//     width: double.infinity,
//     fit: BoxFit.cover,
//     errorBuilder: (context, error, stackTrace) {
//       return Image.network(
//         "https://via.placeholder.com/150", // fallback if broken
//         height: 120,
//         width: double.infinity,
//         fit: BoxFit.cover,
//       );
//     },
//   ),
// ),

ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          "http://assets.ntechagent.com/ihamim_app/1.jpeg",
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(getFirstImage(product.productName),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                        ),
                         Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("ETB ${product.price.toString()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
        
              ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddproductScreen()), // Navigate to product display
                      );
                    },
                    child: Text('add Products'),
                  ),
            ],
          ),
        );
  }),
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
