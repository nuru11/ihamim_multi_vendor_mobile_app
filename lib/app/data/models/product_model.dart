// lib/app/data/models/product_model.dart

class ProductModel {
  final int id;
  final String? productImage; // Nullable
  final String productGallery; // Comma-separated string
  final String productName;
  final String productDescription;
  final double price;
  final int stock;
  final int categoryId;
  final int userId;
  final String phone;
  final String? comment; // Nullable
  final String? location; // Nullable
  final String city;
  final String status; // Should match ENUM values
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    this.productImage,
    required this.productGallery,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.userId,
    required this.phone,
    this.comment,
    this.location,
    required this.city,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON -> Dart
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      productImage: json['productImage'], // Nullable
      productGallery: json['productGallery'] ?? '',
      productName: json['productName'] ?? '',
      productDescription: json['productDescription'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      userId: json['userId'] ?? 0,
      phone: json['phone'] ?? '',
      comment: json['comment'], // Nullable
      location: json['location'], // Nullable
      city: json['city'] ?? '',
      status: json['status'] ?? 'pending', // Default value
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }

  // Convert Dart -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productImage': productImage,
      'productGallery': productGallery,
      'productName': productName,
      'productDescription': productDescription,
      'price': price.toString(),
      'stock': stock,
      'categoryId': categoryId,
      'userId': userId,
      'phone': phone,
      'comment': comment,
      'location': location,
      'city': city,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}