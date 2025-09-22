// lib/app/data/models/user_model.dart

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? defaultAddress;
  final int loyaltyPoints;
  final String? preferredPaymentMethod;
  final String role;
  final String? token; // Optional: for authentication

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.defaultAddress,
    this.loyaltyPoints = 0,
    this.preferredPaymentMethod,
    this.token,
  });

  // Convert JSON -> Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
      defaultAddress: json['default_address'],
      loyaltyPoints: json['loyalty_points'] ?? 0,
      preferredPaymentMethod: json['preferred_payment_method'],
      token: json['token'], // if API returns token
    );
  }

  // Convert Dart -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'default_address': defaultAddress,
      'loyalty_points': loyaltyPoints,
      'preferred_payment_method': preferredPaymentMethod,
      'token': token,
    };
  }
}
