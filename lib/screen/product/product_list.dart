import 'package:flutter/material.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/network/product_network.dart';
import 'product_form.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductNetwork _apiService = ProductNetwork();
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _products = _apiService.fetchProducts();
  }

  void _refreshProducts() {
    setState(() {
      _products = _apiService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    void deleteProduct(int id) async {
      bool success = await _apiService.deleteProduct(id);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
          _refreshProducts();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete product')));
        }
      }
    }

    Future<void> goProductFormScreen(ProductModel product) async {
      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductFormScreen(product: product)));
      if (result == true) _refreshProducts();
    }

    void deleteProductHandler(ProductModel product) => deleteProduct(product.id!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductFormScreen()),
              );
              if (result == true) {
                _refreshProducts();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Quantity: ${product.qty}, Price: ${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async => await goProductFormScreen(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteProductHandler(product),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
