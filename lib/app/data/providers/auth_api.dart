// import 'package:dio/dio.dart';
// import 'package:ihamim_multivendor/app/utils/constants/api_endpoint.dart';

// class AuthApi {
//   final Dio _dio;

//   AuthApi()
//       : _dio = Dio(
//           BaseOptions(
//             baseUrl: ApiEndpoints.baseUrl,
//             connectTimeout: const Duration(seconds: 10),
//             receiveTimeout: const Duration(seconds: 15),
//             headers: {
//               "Content-Type": "application/json",
//               "Accept": "application/json",
//             },
//           ),
//         );

//   /// Login user with email & password
//   Future<Response> login(String email, String password) async {
//     try {
//       final response = await _dio.post(
//         ApiEndpoints.login,
//         data: {
//           "email": email,
//           "password": password,
//         },
//       );

//       return response;
//     } on DioException catch (e) {
//       // Log full error for debugging
//       print("🔴 Login API error: ${e.response?.data ?? e.message}");

//       // Re-throw with cleaner message
//       throw Exception(
//         e.response?.data['message'] ?? "Login failed. Please try again.",
//       );
//     } catch (e) {
//       print("⚠️ Unexpected error: $e");
//       throw Exception("Something went wrong. Try again later.");
//     }
//   }



//   Future<Response> register(String name, String email, String password, String role) async {
//     try {
//       final response = await _dio.post(
//         ApiEndpoints.register,
//         data: {
//           "name": name,
//           "email": email,
//           "password": password,
//           "role": role,
//         },
//       );

//       return response;
//     } on DioException catch (e) {
//       // Log full error for debugging
//       print("🔴 Registration API error: ${e.response?.data ?? e.message}");

//       // Re-throw with cleaner message
//       throw Exception(
//         e.response?.data['message'] ?? "Registration failed. Please try again.",
//       );
//     } catch (e) {
//       print("⚠️ Unexpected error: $e");
//       throw Exception("Something went wrong. Try again later.");
//     }
//   }
// }



// lib/app/data/providers/auth_api.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/data/models/vendor_model.dart';
import 'package:ihamim_multivendor/app/utils/constants/api_endpoint.dart';
import 'package:ihamim_multivendor/app/data/models/user_model.dart';

class AuthApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiEndpoints.baseUrl), // use base url
  );

  Future<UserModel> login(String email, String password) async {
    print("Login called with email: $email, password: $password");
    print("POST to ${ApiEndpoints.login} with data: {email: $email, password: $password}");

    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          "phone": email,
          "password": password,
        },
      );

      // Assume API returns { "user": {...}, "token": "xxxx" }
      final data = response.data;
      print("Response data: $data");
      final userData = data['user'];
      userData['token'] = data['token']; // attach token to user


      // Save user info
    await GetStorage().write("user", data['user']);
    
    // ✅ Save token
    await GetStorage().write("auth_token", data['token']);

      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register(String name, String email, String password, String role) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        },
      );

      final data = response.data;
      final userData = data['user'];
      userData['token'] = data['token'];

      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }



  Future<VendorModel> getSingleVendorApi(String token) async {
    print("Get Single Vendor called with tokennnnnnnnnnnn: $token");
    try {
      final response = await _dio.get(
        ApiEndpoints.getSingleVendor,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final data = response.data;
      print("Get Single Vendor response data: $data");
      final VendorData = data;
      // VendorData['token'] = data['token'];

      return VendorModel.fromJson(VendorData);
    } catch (e) {
      rethrow;
    }
  }
}
