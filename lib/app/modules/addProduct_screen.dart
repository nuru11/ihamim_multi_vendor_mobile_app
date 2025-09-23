import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ihamim_multivendor/app/modules/home/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class AddproductScreen extends StatefulWidget {
  @override
  _AddproductScreenState createState() => _AddproductScreenState();
}

class _AddproductScreenState extends State<AddproductScreen> {
  final _formKey = GlobalKey<FormState>();
  String productName = 'Pro name1';
  String productDescription = 'pro desc1';
  double price = 2.0;
  int stock = 1;
  int categoryId = 2;
  int userId = 36;
  String phone = '09111';
  String comment = 'ccc';
  String location = 'loca1';
  String city = 'city1';
  String status = 'pending';
  File? _image;
  List<File> _galleryImages = []; // New field for product gallery

//   Future<void> _pickImage() async {
//   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//     // Check if the file exists
//     if (await _image!.exists()) {
//       print('Picked image exists: ${_image!.path}');
//     } else {
//       print('Picked image does not exist.');
//     }
//   } else {
//     print('No image selected.');
//   }
// }

  Future<void> _pickGalleryImages() async {
  final pickedFiles = await ImagePicker().pickMultiImage();
  if (pickedFiles != null) {
    setState(() {
      _galleryImages = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });

    // Check if all picked gallery images exist
    for (var image in _galleryImages) {
      if (await image.exists()) {
        print('Gallery image exists: ${image.path}');
      } else {
        print('Gallery image does not exist: ${image.path}');
      }
    }
  }
}
  Future<void> _postProduct() async {
    
      final uri = Uri.parse('http://192.168.1.16:4000/api/products');
      var request = http.MultipartRequest('POST', uri);
      request.fields['productName'] = productName;
      request.fields['productDescription'] = productDescription;
      request.fields['price'] = price.toString();
      request.fields['stock'] = stock.toString();
      request.fields['categoryId'] = categoryId.toString();
      request.fields['userId'] = userId.toString();
      request.fields['phone'] = phone;
      // request.fields['comment'] = comment;
      request.fields['location'] = location;
      request.fields['city'] = city;
      request.fields['status'] = status;

      // if (_image != null) {
      //   request.files.add(await http.MultipartFile.fromPath('product_image', _image!.path));
      // }

      // Add product gallery images
      if (_galleryImages.isNotEmpty) {
        // Convert gallery images to a comma-separated string (or handle the upload in a different way as needed)
        for (var image in _galleryImages) {
          request.files.add(await http.MultipartFile.fromPath('product_gallery[]', image.path));
        }
      }

      final response = await request.send();
      print('$_galleryImages         aaaaaaaaaaaaaaaaaaa');
      if (response.statusCode == 201) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonResponse = json.decode(responseString);
        print(jsonResponse);
        // Handle success (e.g., show a message or navigate)
      } else {
        print('Failed to post product');
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter product name' : null,
                  onChanged: (value) => productName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Description'),
                  validator: (value) => value!.isEmpty ? 'Please enter product description' : null,
                  onChanged: (value) => productDescription = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter price' : null,
                  onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter stock' : null,
                  onChanged: (value) => stock = int.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter category ID' : null,
                  onChanged: (value) => categoryId = int.tryParse(value) ?? 1,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'User ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter user ID' : null,
                  onChanged: (value) => userId = int.tryParse(value) ?? 36,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
                  onChanged: (value) => phone = value,
                ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Comment'),
                //   validator: (value) => value!.isEmpty ? 'Please enter a comment' : null,
                //   onChanged: (value) => comment = value,
                // ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) => value!.isEmpty ? 'Please enter location' : null,
                  onChanged: (value) => location = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) => value!.isEmpty ? 'Please enter city' : null,
                  onChanged: (value) => city = value,
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: ['pending', 'active', 'inactive', 'rejected'] // Updated options
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: _pickImage,
                //   child: Text('Pick Main Image'),
                // ),
                if (_image != null) ...[
                  SizedBox(height: 20),
                  Image.file(_image!, height: 100),
                ],
                ElevatedButton(
                  onPressed: _pickGalleryImages,
                  child: Text('Pick Gallery Images'),
                ),
                if (_galleryImages.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    children: _galleryImages.map((image) => Image.file(image, height: 100)).toList(),
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _postProduct,
                  child: Text('Post Product'),
                ),
                SizedBox(height: 70),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to product display
                    );
                  },
                  child: Text('View Products'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:ihamim_multivendor/app/controllers/auth_controller.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final storage = GetStorage();
//   final AuthController authController = Get.find<AuthController>();

//   @override
//   void initState() {
//     super.initState();

//     // final user = storage.read("user");
//     // final token = storage.read("auth_token");

    
//      final token = GetStorage().read("auth_token");
//      print("Retrieved token: $token");
// if (token != null) {
//   authController.getSingleVendorController(token);
// } else {
//   print("Token is null! User not logged in?");
// }

//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = storage.read("user");

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Multi Vendor App"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               storage.erase();
//               Get.offAllNamed("/login");
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (authController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (user == null) {
//           return const Center(child: Text("No user data found"));
//         }

//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Welcome, ${user['email']} 👋",
//                   style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text("User ID: ${user['id']}"),
//               Text("Role: ${user['role']}"),
//               const SizedBox(height: 20),

//               if (user['role'] == 'vendor')
//                 Obx(() {
//                   final vendor = authController.vendor.value;
//                   if (vendor == null) {
//                     return const Text("Loading vendor data...");
//                   }
//                   return Column(
//                     children: [
//                       Text("Store: ${vendor.storeName}"),
//                       Text("Phone: ${vendor.phone}"),
//                       Text("Status: ${vendor.status}"),
//                       Text("Rating: ${vendor.rating}"),
//                     ],
//                   );
//                 }),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
