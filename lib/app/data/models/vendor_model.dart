// lib/app/data/models/vendor_model.dart

class VendorModel {
  final int id;
  final int userId;
  final String storeName;
  final String rating;
  final String phone;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? token; // Optional: for authentication

  VendorModel({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.rating,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,

    
    this.token,
  });

  // Convert JSON -> Dart
  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      storeName: json['storeName'] ?? '',
      rating: json['rating'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      token: json['token'], // if API returns token
    );
  }

  // Convert Dart -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'storeName': storeName,
      'rating': rating,
      'phone': phone,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
    };
  }
}


// lib/app/controllers/auth_controller.dart