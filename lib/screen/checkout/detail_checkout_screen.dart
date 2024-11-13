import 'package:flutter/material.dart';
import 'package:vape_store/models/trolley_model.dart';

class DetailCheckoutScreen extends StatelessWidget {
  DetailCheckoutScreen({super.key});

  final List<TrolleyModel> cartItems = [
    TrolleyModel(
      id: 1,
      idCheckout: 101,
      idProduct: 1001,
      trolleyIdUser: 2001,
      idUser: 3001,
      qty: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      idTrolley: 4001,
      name: "Product 1",
      price: 25.0,
      category: "Electronics",
      description: "This is a great electronic product.",
    ),
    TrolleyModel(
      id: 3,
      idCheckout: 103,
      idProduct: 1003,
      trolleyIdUser: 2003,
      idUser: 3003,
      qty: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      idTrolley: 4003,
      name: "Product 3",
      price: 10.0,
      category: "Clothing",
      description: "Comfortable and stylish clothing.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Order',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final itemTotal = item.price * item.qty;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.network(
                            'https://via.placeholder.com/50', // Placeholder for product image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product ID: ${item.idProduct}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Price: \$${item.price}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantity: ${item.qty}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${itemTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${200}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to complete the transaction
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction Completed!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Complete Transaction',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
