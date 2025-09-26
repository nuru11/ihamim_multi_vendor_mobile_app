import 'package:flutter/material.dart';
import 'package:ihamim_multivendor/app/data/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  // Helper to get first image
  String getFirstImage(String gallery) {
    if (gallery.isEmpty) return "https://via.placeholder.com/150";
    final parts = gallery.split(",");
    return parts.first.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.productName),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image Gallery
            SizedBox(
              height: 250,
              child: PageView(
                children: product.productGallery
                    .split(",")
                    .map((img) => Image.network(
                          img.trim(),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                              "https://via.placeholder.com/150"),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Product Info
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
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 20),

                  // 🔹 Additional Info
                  if (product.carModel != null)
                    Text("Model: ${product.carModel}",
                        style: const TextStyle(fontSize: 14)),
                  if (product.carCondition != null)
                    Text("Condition: ${product.carCondition}",
                        style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 20),

                  // 🔹 Contact / Buy Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart / buy logic
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text("Buy Now"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Chat with seller logic
                          },
                          child: const Text("Chat Seller"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}