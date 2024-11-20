import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';
import 'package:vape_store/screen/checkout/order_screen.dart';
import 'package:vape_store/utils/money.dart';

class TrolleyScreen extends StatefulWidget {
  const TrolleyScreen({super.key});

  @override
  State<TrolleyScreen> createState() => _TrolleyScreenState();
}

class _TrolleyScreenState extends State<TrolleyScreen> {
  final Map<int, bool> selectedItems = {};
  final Map<int, int> itemCounts = {};
  List<TrolleyModel> cartItems = [];

  void selectCheckbox(bool? checked, TrolleyModel item) {
    setState(() {
      if (checked == true) {
        cartItems.add(item);
      } else {
        cartItems.remove(item);
      }
    });
  }

  // Calculate total price based on selected cart items
  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.qty;
    }
    return total;
  }

  void _incrementCount(bool isSelected, TrolleyModel item) {
    setState(() {
      item.qty++;
      if (isSelected) calculateTotalPrice();
    });
  }

  void _decrementCount(bool isSelected, TrolleyModel item) {
    setState(() {
      if (item.qty > 1) {
        item.qty--;
        if (isSelected) calculateTotalPrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<TrolleyBloc>().add(GetTrolleyEvent());
    double totalPrice = calculateTotalPrice(); // Assume a function to calculate total price
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display Total Price
              Text(
                'Total Price: ${formatPrice(totalPrice)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Checkout Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return OrderScreen(productTrolley: cartItems);
                    },
                  ));
                },
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Trolley'),
      ),
      body: BlocBuilder<TrolleyBloc, TrolleyState>(
        builder: (context, state) {
          if (state is TrolleyLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrolleyErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is TrolleyLoadState) {
            List<TrolleyModel> trolleys = state.trolleys ?? [];
            return ListView.builder(
              itemCount: trolleys.length,
              itemBuilder: (context, index) {
                var item = trolleys[index];
                bool isSelected = cartItems.contains(item);
                itemCounts.putIfAbsent(item.idProduct, () => item.trolleyQty);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? checked) {
                            selectCheckbox(checked, item);
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProductDetailScreen(id: item.idProduct);
                            }));
                          },
                          child: Image.network(
                            'lib/images/banner1.png',
                            // item.imageUrl, // Assuming TrolleyModel has an 'imageUrl' field
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Price: ${formatPrice(item.price)}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              // const SizedBox(height: 4),
                              // Text(
                              //   'qty: ${item.qty}',
                              //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              // ),
                              const SizedBox(height: 4),
                              Text(
                                'Type: ${item.type ?? 'null'}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              iconSize: 20,
                              onPressed: () => _decrementCount(isSelected, item),
                              icon: const Icon(Icons.remove, size: 20),
                            ),
                            Text(item.trolleyQty.toString(), style: const TextStyle(fontSize: 16)),
                            IconButton(
                              iconSize: 20,
                              onPressed: () {
                                _incrementCount(isSelected, item);
                              },
                              icon: const Icon(Icons.add, size: 20),
                            ),
                          ],
                        ),
                        BlocListener<TrolleyBloc, TrolleyState>(
                          listener: (context, trolleyState) {
                            if (trolleyState is TrolleyCaseState) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success')));
                            } else if (trolleyState is TrolleyErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(trolleyState.message)));
                            }
                          },
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () {
                              context.read<TrolleyBloc>().add(RemoveTrolleyEvent(idTrolley: item.idTrolley));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}
