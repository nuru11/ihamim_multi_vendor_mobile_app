import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/controllers/wishlist_controller.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/modules/auth/login_screen.dart';
import 'package:ihamim_multivendor/app/modules/chat_screen.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentIndex = 0;
  final ScrollController _thumbnailController = ScrollController();
  final PageController _pageController = PageController();

  final box = GetStorage();

  late int currentUserId;

  final RxMap<int, int> unreadCounts = <int, int>{}.obs;

  // Dummy images
  final List<String> categoryImages = List.generate(
    7,
    (index) => "http://assets.ntechagent.com/ihamim_app/${index + 1}.jpeg",
  );

  void _scrollToThumbnail(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double offset = (index * 68.0) - (screenWidth / 2) + 34; // 60 width + 8 spacing
    if (offset < 0) offset = 0;
    _thumbnailController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  @override
  void initState() {
    super.initState();

    final user = box.read("user") ?? {};
    currentUserId = user["id"];

  
  }

  @override
  void dispose() {
    _thumbnailController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  void _openChat(int otherUserId) {
    // Reset unread count
    unreadCounts[otherUserId] = 0;
  }

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.product.productName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: mainColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => wishlistController.toggleWishlist(widget.product.id),
              child: Obx(() {
                final isWished = wishlistController.isInWishlist(widget.product.id);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: categoryImages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                  _scrollToThumbnail(index); // Auto-scroll thumbnails
                },
                itemBuilder: (context, index) => InteractiveViewer(
                  child: Image.network(
                    categoryImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Image.network("https://via.placeholder.com/150"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(categoryImages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 12 : 8,
                  height: currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? mainColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            // Thumbnail Carousel
            SizedBox(
              height: 60,
              child: ListView.separated(
                controller: _thumbnailController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categoryImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => currentIndex = index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      _scrollToThumbnail(index);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: currentIndex == index ? mainColor : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(categoryImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Product Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.productName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("ETB ${widget.product.price}",
                      style:  TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: mainColor)),
                  const SizedBox(height: 12),
                  Text(widget.product.productDescription,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 20),
                  Text("Model: ${widget.product.carModel}", style: const TextStyle(fontSize: 14)),
                  Text("Condition: ${widget.product.carCondition}",
                      style: const TextStyle(fontSize: 14)),

                      Text("Seller: ${widget.product.userName}", style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("id: ${widget.product.userId}", style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 20),
                      Text("Location: $currentUserId", style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 20),
                  Text("current $currentUserId")
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final token = GetStorage().read("auth_token");
      if (token == null || token.isEmpty) {
        // Not logged in → go to Login
        Get.to(() => LoginScreen());
      } else {
        // Logged in → go to Add Product
        print("Call with seller user logged in");
      }
                },
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: Row(children: const [
                  Text("Call Now", style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.call, color: Colors.white),
                ]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  final token = GetStorage().read("auth_token");
      if (token == null || token.isEmpty) {
        // Not logged in → go to Login
        Get.to(() => LoginScreen());
      } else {
        // Logged in → go to Add Product
        print("Chat with seller user logged in");

         _openChat(widget.product.userId);
                Get.to(() => ChatScreen(
                      currentUserId: currentUserId,
                      otherUserId: widget.product.userId, // Dummy other user ID
                      otherUserName: widget.product.userName,
                    ));
      }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: mainColor, width: 2),
                ),
                child: Row(children: [
                  Text("Chat Seller", style: TextStyle(color: mainColor, fontSize: 16)),
                  const SizedBox(width: 8),
                  Icon(Icons.chat, color: mainColor),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








////////////////////////////////////////  real images


// class ProductDetailScreen extends StatelessWidget {
//   final ProductModel product;

//   const ProductDetailScreen({super.key, required this.product});

//   String getFirstImage(String gallery) {
//     if (gallery.isEmpty) return "https://via.placeholder.com/150";
//     return gallery.split(",").first.trim();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(product.productName, style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share, color: Colors.white),
//             onPressed: () {
//               // Share logic here
//             },
//           ),

//           IconButton(
//             icon: const Icon(Icons.favorite_border, color: Colors.white),
//             onPressed: () {
//               // Favorite logic here
//             },
//           ),
//          ],
//         backgroundColor: mainColor,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(bottom: 80), // Leave space for buttons
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Gallery
//             SizedBox(
//               height: 250,
//               child: PageView(
//                 children: product.productGallery
//                     .split(",")
//                     .map((img) => Image.network(
//                           img.trim(),
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) =>
//                               Image.network("https://via.placeholder.com/150"),
//                         ))
//                     .toList(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Product Info
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(product.productName,
//                       style: const TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Text("ETB ${product.price}",
//                       style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red)),
//                   const SizedBox(height: 12),
//                   Text(product.productDescription,
//                       style: TextStyle(fontSize: 14, color: Colors.grey[700])),
//                   const SizedBox(height: 20),
//                   Text("Model: ${product.carModel}",
//                       style: const TextStyle(fontSize: 14)),
//                   Text("Condition: ${product.carCondition}",
//                       style: const TextStyle(fontSize: 14)),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Fixed Bottom Buttons
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, -2)),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Buy now logic
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: mainColor),
//                 child: Row(children: [
//                    const Text("Call Now", style: TextStyle(color: Colors.white, fontSize: 16)),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.call, color: Colors.white), // Call icon
//                    ]
//                    ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//   child: OutlinedButton(
//     onPressed: () {
//       // Chat logic
//     },
//     style: OutlinedButton.styleFrom(
//       side: BorderSide(color: Color(0xFF38A001), width: 2), // Set border color and width
//     ),
//     child: Row(children: [ 
//       Text("Chat Seller", style: TextStyle(color: mainColor, fontSize: 16)),
//       const SizedBox(width: 8),
//       Icon(Icons.chat, color: mainColor), // Chat icon
//       ]),
//   ),
// ),
//           ],
//         ),
//       ),
//     );
//   }
// }
