// import 'package:dio/dio.dart';
// import '../providers/auth_api.dart';

// class AuthRepository {
//   final AuthApi _api;

//   AuthRepository(this._api);

//   Future<Response> login(String email, String password) {
//     return _api.login(email, password);
//   }


//   Future<Response> register(String name, String email, String password, String role) {
//     return _api.register(name, email, password, role);
//   }
// }


// lib/app/data/repositories/auth_repository.dart
import 'package:ihamim_multivendor/app/data/models/user_model.dart';
import 'package:ihamim_multivendor/app/data/models/vendor_model.dart';
import 'package:ihamim_multivendor/app/data/providers/auth_api.dart';
import 'package:ihamim_multivendor/app/services/storage_service.dart';

class AuthRepository {
  final AuthApi _authApi;
  final StorageService _storage;

  AuthRepository(this._authApi, this._storage);

  Future<UserModel> login(String email, String password) async {
    print("Login called with email: $email, password: $password");
    final user = await _authApi.login(email, password);
    await _storage.saveUser(user); // persist user
    return user;
  }

  Future<UserModel> register(String name, String email, String password, String role) async {
    final user = await _authApi.register(name, email, password, role);
    await _storage.saveUser(user);
    return user;
  }


  Future<VendorModel> getSingleVendorRepository(String token) async {
    print("Get Single Vendor called with token: $token"); 
    return await _authApi.getSingleVendorApi(token);
  }

  Future<UserModel?> getSavedUser() async {
    return _storage.getUser();
  }

  Future<void> logout() async {
    await _storage.clearUser();
  }
}
