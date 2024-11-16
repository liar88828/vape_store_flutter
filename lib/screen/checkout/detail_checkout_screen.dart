import 'package:flutter/material.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/network/checkout_network.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/utils/money.dart';

class DetailCheckoutScreen extends StatefulWidget {
  final CheckoutModel? checkout;
  final int? idCheckout;
  DetailCheckoutScreen({
    super.key,
    required this.checkout,
    required this.idCheckout,
  });

  @override
  State<DetailCheckoutScreen> createState() => _DetailCheckoutScreenState();
}

class _DetailCheckoutScreenState extends State<DetailCheckoutScreen> {
  final CheckoutNetwork _checkoutNetwork = CheckoutNetwork();
  final TrolleyNetwork _trolleyNetwork = TrolleyNetwork();
  Future<List<TrolleyModel>>? _trolleyData;
  Future<CheckoutModel>? _checkoutData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    if (widget.idCheckout != null) {
      // print(widget.idCheckout);
      _checkoutData = _checkoutNetwork.fetchId(widget.idCheckout!);
      _trolleyData = _trolleyNetwork.fetchTrolleyCheckout(widget.idCheckout!);
      // print(_trolleyData);
      // print(_checkoutData);
    }

    setState(() {});
  }

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
              child: FutureBuilder<List<TrolleyModel>>(
                  future: _trolleyData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Your trolley is empty.'));
                    } else {
                      return Column(
                        children: snapshot.data!.map((data) {
                          return CardTrolley(data);
                        }).toList(),
                      );
                    }
                  }),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 16),
            FutureBuilder(
                future: _checkoutData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Your checkout is empty.'));
                  } else {
                    final data = snapshot.data;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Payment',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  data!.paymentMethod,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                                Text(
                                  formatPrice(data.paymentPrice),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  data.deliveryMethod,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                                Text(
                                  formatPrice(data.deliveryPrice),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatPrice(data.total),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }),
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

  Card CardTrolley(TrolleyModel item) {
    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.network(
              'lib/images/banner1.png', // Placeholder for product image
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
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(item.price),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.trolleyQty}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Text(
              '${formatPrice(item.price * item.trolleyQty)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
