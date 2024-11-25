import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';
import 'package:vape_store/screen/checkout/order_screen.dart';
import 'package:vape_store/utils/money.dart';

class TrolleyScreen extends StatelessWidget {
  const TrolleyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TrolleyBloc>().add(TrolleyLoadsEvent());

    void selectCheckbox(bool checked, TrolleyModel item) => context.read<TrolleyBloc>().add(TrolleySelectEvent(checked, item));
    void incrementCount(TrolleyModel item) => context.read<TrolleyBloc>().add(TrolleyIncrementEvent(item));
    void decrementCount(TrolleyModel item) => context.read<TrolleyBloc>().add(TrolleyDecrementEvent(item));
    void removeHandler(TrolleyModel item) => context.read<TrolleyBloc>().add(TrolleyRemoveEvent(idTrolley: item.idTrolley));

    void goProductScreen(TrolleyModel item) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ProductDetailScreen(
          id: item.idProduct,
          redirect: 'trolley',
          lastId: 0,
        );
      }));
    }

    void goOrderScreen(TrolleyState stateTrolley) {
      if (stateTrolley.cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return OrderScreen(productTrolley: stateTrolley.cartItems);
          },
        ));
      }
    }

    // double totalPrice = calculateTotalPrice(); // Assume a function to calculate total price
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: BlocSelector<TrolleyBloc, TrolleyState, TrolleyState>(
            selector: (stateTrolley) => stateTrolley,
            builder: (context, stateTrolley) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price: ${formatPrice(stateTrolley.totalPrice)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => goOrderScreen(stateTrolley),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Trolley'),
      ),
      body: BlocConsumer<TrolleyBloc, TrolleyState>(
        listener: (context, stateListener) {
          if (stateListener is TrolleyCaseState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success')));
          } else if (stateListener is TrolleyErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateListener.message)));
          } else if (stateListener is TrolleyRemoveState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateListener.message)));
            context.read<TrolleyBloc>().add(TrolleyLoadsEvent());
          }
        },
        buildWhen: (previous, current) {
          if (current is TrolleyLoadingState) {
            return true;
          } else if (current is TrolleyErrorState) {
            return true;
          } else if (current is TrolleyLoadsState) {
            return true;
          } else if (previous is TrolleyInitial && current is TrolleyInitial) {
            final cartItems = previous.cartItems != current.cartItems;
            final trolleys = previous.trolleys != current.trolleys;
            return cartItems && trolleys;
          }
          return false;
        },
        builder: (context, state) {
          if (state is TrolleyLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrolleyErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is TrolleyLoadsState) {
            final trolleys = state.trolleys;
            return ListView.builder(
              itemCount: trolleys.length,
              itemBuilder: (context, index) {
                var item = trolleys[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocSelector<TrolleyBloc, TrolleyState, bool>(
                          selector: (state) {
                            return state.cartItems.contains(item);
                          },
                          builder: (context, stateBool) {
                            return Checkbox(
                              value: stateBool,
                              onChanged: (bool? checked) => selectCheckbox(checked ?? false, item),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () => goProductScreen(item),
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
                              onPressed: () => decrementCount(item),
                              icon: const Icon(Icons.remove, size: 20),
                            ),
                            BlocSelector<TrolleyBloc, TrolleyState, TrolleyState>(
                              selector: (state) {
                                return state;
                              },
                              builder: (context, state) {
                                return Text(item.trolleyQty.toString(), style: const TextStyle(fontSize: 16));
                              },
                            ),
                            IconButton(
                              iconSize: 20,
                              onPressed: () => incrementCount(item),
                              icon: const Icon(Icons.add, size: 20),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => removeHandler(item),
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
