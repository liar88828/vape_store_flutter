import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/order/order_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/profile_screen.dart';
import 'package:vape_store/utils/money.dart';

class DetailCheckoutScreen extends StatelessWidget {
  final CheckoutModel? checkout;
  final int idCheckout;
  final bool isFromProfile;
  const DetailCheckoutScreen({
    super.key,
    this.isFromProfile = false,
    required this.checkout,
    required this.idCheckout,
  });

  @override
  Widget build(BuildContext context) {
    if (isFromProfile == true) {
      context.read<OrderBloc>().add(CheckoutDetailEvent(idCheckout: idCheckout));
    }
    context.read<TrolleyBloc>().add(TrolleyCheckoutEvent(idCheckout: idCheckout));

    void completeHandler() {
      // Add functionality to complete the transaction
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction Completed!')),
      );
      if (isFromProfile) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }

    void backScreenHandler() {
      if (isFromProfile == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      } else {
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => backScreenHandler(),
        ),
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
              child: BlocBuilder<TrolleyBloc, TrolleyState>(builder: (context, stateTrolley) {
                if (stateTrolley is TrolleyLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (stateTrolley is TrolleyErrorState) {
                  return Center(child: Text('Error: ${stateTrolley.message}'));
                } else if (stateTrolley is TrolleyLoadsState) {
                  return Column(
                      children: stateTrolley.trolleys.map((data) {
                    return cardTrolley(data);
                  }).toList());
                } else {
                  return const Text('Trolley Something Error Bloc or Api');
                }
              }),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 16),
            BlocBuilder<OrderBloc, OrderState>(builder: (context, stateCheckout) {
              if (stateCheckout is CheckoutLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateCheckout is CheckoutErrorState) {
                return Center(child: Text(stateCheckout.message));
              } else if (stateCheckout is CheckoutLoadState) {
                final data = stateCheckout.checkout;
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
                              data.paymentMethod,
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
              } else {
                return const Text('Order Something Error Bloc or Api');
              }
            }),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => completeHandler(),
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

  Widget cardTrolley(TrolleyModel item) {
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
              formatPrice(item.price * item.trolleyQty),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
