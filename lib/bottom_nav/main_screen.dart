import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/modules/addProduct_screen.dart';
import 'package:ihamim_multivendor/app/modules/auth/login_screen.dart';
import 'package:ihamim_multivendor/app/modules/auth/profile_screen.dart';
import 'package:ihamim_multivendor/app/modules/home/home_screen.dart';
import 'package:ihamim_multivendor/app/modules/wishlist_screen.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';
import 'package:ihamim_multivendor/bottom_nav/nav_bar.dart';
import 'package:ihamim_multivendor/bottom_nav/nav_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: HomeScreen(),
        navKey: homeNavKey,
      ),
      NavModel(
        page: WishlistScreen(),
        navKey: searchNavKey,
      ),
      NavModel(
        page: HomeScreen(),
        navKey: notificationNavKey,
      ),
      NavModel(
        page: ProfileScreen(),
        navKey: profileNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
                    key: page.navKey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.page)
                      ];
                    },
                  ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
  margin: const EdgeInsets.only(top: 10),
  height: 64,
  width: 64,
  child: FloatingActionButton(
    backgroundColor: Colors.white,
    elevation: 0,
    onPressed: () {
      final token = GetStorage().read("auth_token");
      if (token == null || token.isEmpty) {
        // Not logged in → go to Login
        Get.toNamed('/login');
      } else {
        // Logged in → go to Add Product
        Get.to(() => AddproductScreen());
      }
    },
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 3, color: mainColor),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Icon(
      Icons.add,
      color: mainColor,
    ),
  ),
),

        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => tab == 1 ? LoginScreen() : tab == 2 ? HomeScreen() : Page(tab: tab),
                  ),
                );
              },
              child: const Text('Go to page'),
            )
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final int tab;

  const Page({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Tab $tab')),
      body: Center(child: Text('Tab $tab')),
    );
  }
}