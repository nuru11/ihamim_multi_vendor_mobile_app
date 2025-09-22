import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDisplayScreen extends StatefulWidget {
  const ProductDisplayScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDisplayScreenState createState() => _ProductDisplayScreenState();
}

class _ProductDisplayScreenState extends State<ProductDisplayScreen> {
  List<dynamic> products = []; // To hold the product data

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final uri = Uri.parse('http://192.168.109.3:4000/api/products'); // Update URL as needed
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body); // Decode JSON response
        print(products);
      });
    } else {
      print('Failed to load products');
    }
  }

  String _getFullImagePath(String imagePath) {
    // Assuming the base URL for images is configured
    return 'http://192.168.109.3:4000/$imagePath'; // Adjust this based on your API structure
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Products')),
    body: products.isEmpty
        ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
        : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(product['productName'] ?? 'No Name'),
                  subtitle: Text(product['productDescription'] ?? 'No Description'),
                  trailing: Text('\$${double.tryParse(product['price'])?.toStringAsFixed(2) ?? '0.00'}'), // Convert string to double
                  // leading: product['productImage'] != null
                  //     ? Image.network('../../backend/ihamim_node/uploads${(product['productImage'])}', width: 50, fit: BoxFit.cover)
                  //     : Icon(Icons.image, size: 50),
                  leading: product['productImage'] != null
                      ? Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_XfY1oOfahJijjx9RpgVRVXg9R6Eo6GCg4g&s", width: 50, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50),
                  onTap: () {
                    // Optionally navigate to product details page
                    print('../../../../backend/ihamim_node/uploads/${(product['productImage'])}');
                  },
                ),
              );
            },
          ),
  );
}
}