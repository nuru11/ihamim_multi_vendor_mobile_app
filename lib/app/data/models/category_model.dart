// lib/app/data/models/product_model.dart


class CategoryModel {
  final int id;
  final String? categoryImage; // Nullable
  final String categoryName; // Comma-separated string
  final String status; // Should match ENUM values
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    this.categoryImage,
    required this.categoryName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON -> Dart
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryImage: json['category_image'], // Nullable
      categoryName: json['category_name'] ?? '', // Comma-separated string 
      status: json['status'] ?? 'active', // Default value
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }

  // Convert Dart -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryImage': categoryImage,
      'categoryName': categoryName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}