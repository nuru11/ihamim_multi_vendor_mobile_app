import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final user = box.read("user") ?? {};
    final token = box.read("auth_token");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              box.remove("user");
              box.remove("auth_token");
              Get.offAllNamed("/login"); // redirect to login after logout
            },
          )
        ],
      ),
      body: token == null
          ? Center(
              child: ElevatedButton(
                onPressed: () => Get.toNamed("/login"),
                child: const Text("Login"),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user["profile_image"] != null &&
                            user["profile_image"].toString().isNotEmpty
                        ? NetworkImage(user["profile_image"])
                        : const AssetImage("assets/images/avatar.png")
                            as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user["name"] ?? "Guest User",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user["phone"] ?? user["email"] ?? "",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text("Wishlist"),
                    onTap: () => Get.toNamed("/wishlist"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout",
                        style: TextStyle(color: Colors.red)),
                    onTap: () {
                      box.remove("user");
                      box.remove("auth_token");
                      Get.offAllNamed("/login");
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
