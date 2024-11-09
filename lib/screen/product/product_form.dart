import 'package:flutter/material.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/network/product_network.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _apiService = ProductNetwork();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _qtyController.text = widget.product!.qty.toString();
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
    }
  }

  Future<void> _saveProduct() async {
    final product = ProductModel(
      id: widget.product?.id,
      id_user: 1, // Example user ID; replace with actual data
      name: _nameController.text,
      qty: int.parse(_qtyController.text),
      price: int.parse(_priceController.text),
      description: _descriptionController.text,
    );

    if (widget.product == null) {
      await _apiService.createProduct(product);
    } else {
      await _apiService.updateProduct(product);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(widget.product == null ? 'Add Product' : 'Edit Product')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: _qtyController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProduct, child: Text('Save')),
            ],
          ),
        ));
  }
}
