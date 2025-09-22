import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/binding/auth_binding.dart';
import 'package:ihamim_multivendor/app/modules/auth/login_screen.dart';
import 'package:ihamim_multivendor/app/modules/auth/register_screen.dart';
import '../modules/home/home_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () =>  HomeScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
     name: "/register",
     page: () => RegisterScreen(),
     binding: AuthBinding(),
    ),

  ];
}
