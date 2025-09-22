import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  // Get controller via binding (AuthBinding)
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxString selectedRole = "customer".obs; // default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
                const SizedBox(height: 16),
                // Role selection
                DropdownButtonFormField<String>(
                  value: selectedRole.value,
                  items: const [
                    DropdownMenuItem(value: "customer", child: Text("Customer")),
                    DropdownMenuItem(value: "vendor", child: Text("Vendor")),
                  ],
                  onChanged: (value) {
                    if (value != null) selectedRole.value = value;
                  },
                  decoration: const InputDecoration(labelText: "Role"),
                ),
                const SizedBox(height: 24),
                authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final role = selectedRole.value;

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            Get.snackbar("Error", "All fields are required");
                            return;
                          }

                          authController.register(
                              name, email, password, role);
                        },
                        child: const Text("Register"),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Already have an account? Login"),
                )
              ],
            )),
      ),
    );
  }
}
