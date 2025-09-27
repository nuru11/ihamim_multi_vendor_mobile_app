// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class AuthController extends GetxController {
//   final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:4000/api/auth/login"));
//   final storage = GetStorage();

//   var isLoading = false.obs;

//   Future<void> login(String email, String password) async {
//     try {
//       isLoading.value = true;

//       final response = await _dio.post("/login", data: {
//         "email": email,
//         "password": password,
//       });

//       if (response.statusCode == 200 && response.data["success"] == true) {
//         // Save token
//         storage.write("token", response.data["token"]);
//         storage.write("user", response.data["user"]);

//         Get.snackbar("Success", "Login successful");
//         Get.offAllNamed("/home"); // navigate to home
//       } else {
//         Get.snackbar("Error", "Invalid email or password");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class AuthController extends GetxController {
//   final Dio _dio = Dio(BaseOptions(
//   baseUrl: "http://192.168.109.3:4000/api/auth",
//   connectTimeout: const Duration(seconds: 10),
//   receiveTimeout: const Duration(seconds: 10),
// ));
//   final storage = GetStorage();

//   var isLoading = false.obs;

//   Future<void> login(String email, String password) async {
//     try {
//       isLoading.value = true;

//       final response = await _dio.post("/login", data: {
//         "email": "vendor2@g.com",
//         "password": '123456',
//       });

//       print(response.data);

//       if (response.statusCode == 200 ) {
//         // Save token
//         storage.write("token", response.data["token"]);
//         storage.write("user", response.data["user"]);

//         Get.snackbar("Success", "Login successful");
//         Get.offAllNamed("/home"); // navigate to home
//       } else {
//         Get.snackbar("Error", "Invalid email or password");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong: $e");
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../data/repositories/auth_repository.dart';

// class AuthController extends GetxController {
//   final AuthRepository repository;
//   final storage = GetStorage();

//   AuthController(this.repository);

//   var isLoading = false.obs;

//   Future<void> login(String email, String password) async {
//     try {
//       isLoading.value = true;

//       final response = await repository.login(email, password);
//       print(response.data);

//       if (response.statusCode == 200) {
//         storage.write("token", response.data["token"]);
//         storage.write("user", response.data["user"]);

//         Get.snackbar("Success", "Login successful");
//         Get.offAllNamed("/home");
//       } else {
//         Get.snackbar("Error", "Invalid email or password");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong: $e");
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }



//   Future<void> registration(String name, String email, String password, String role) async {
//     try {
//       isLoading.value = true;

//       final response = await repository.register(name, email, password, role);
//       print(response.data);
//       print(response.statusCode);

//       if (response.statusCode == 201) {
//         storage.write("token", response.data["token"]);
//         storage.write("user", response.data["user"]);

//         Get.snackbar("Success", "Registration successful");
//         Get.offAllNamed("/home");
//       } else {
//         Get.snackbar("Error", "Invalid email or password");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong: $e");
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



// lib/app/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/data/models/user_model.dart';
import 'package:ihamim_multivendor/app/data/models/vendor_model.dart';
import 'package:ihamim_multivendor/app/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController(this._repository);

  var user = Rx<UserModel?>(null);
  var vendor = Rx<VendorModel?>(null);
  var isLoading = false.obs;

  @override
void onReady() {
  super.onReady();
  _loadUser();
}

Future<void> _loadUser() async {
  user.value = await _repository.getSavedUser();
}

  Future<void> login(String email, String password) async {
    print("Login called with email: $email, password: $password");
    try {
      isLoading.value = true;
      final loggedInUser = await _repository.login(email, password);
      print("Logged in user: $loggedInUser");
      user.value = loggedInUser;

      if (loggedInUser != null) {
        Get.snackbar("Success", "Login successful");
        Get.offAllNamed("/mainscreen");
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password, String role) async {
    try {
      isLoading.value = true;
      final registeredUser = await _repository.register(name, email, password, role);
      user.value = registeredUser;
    } catch (e) {
      Get.snackbar("Register Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> getSingleVendorController(String token) async {
    print("Fetching vendor with token: $token");
  try {
    isLoading.value = true;
    final vendorData = await _repository.getSingleVendorRepository(token);
    print("Fetched vendor: $vendorData");
    vendor.value = vendorData;   // assign to the Rx<VendorModel?>
  } catch (e) {
    Get.snackbar("Vendor Error", e.toString());
    print("Error fetching vendor: $e");
  } finally {
    isLoading.value = false;
  }
}


  Future<void> logout() async {
    await _repository.logout();
    user.value = null;
  }
}
