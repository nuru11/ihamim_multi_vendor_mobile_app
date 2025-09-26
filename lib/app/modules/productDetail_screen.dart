import 'package:flutter/material.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

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
        iconTheme: const IconThemeData(color: Colors.white),
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
