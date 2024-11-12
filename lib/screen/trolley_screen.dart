import 'package:flutter/material.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';
import 'package:vape_store/screen/checkout/order_screen.dart';
import 'package:vape_store/utils/pref_user.dart';

class TrolleyScreen extends StatefulWidget {
  const TrolleyScreen({super.key});

  @override
  _TrolleyScreenState createState() => _TrolleyScreenState();
}

class _TrolleyScreenState extends State<TrolleyScreen> {
  final TrolleyNetwork _trolleyNetwork = TrolleyNetwork();
  final Map<int, bool> selectedItems = {};
  final Map<int, int> itemCounts = {};
  late Future<List<TrolleyModel>> _trolleyData;
  List<TrolleyModel> cartItems = [];

  UserModel? _userModel;
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshTrolley(int idUser) {
    setState(() {
      _trolleyData = _trolleyNetwork.fetchTrolley(idUser);
    });
  }

  // Function to load trolley items
  Future<void> _refreshData() async {
    _userModel = await loadUserData();
    if (_userModel != null) {
      _trolleyData = _trolleyNetwork.fetchTrolley(_userModel!.id);
      setState(() {});
    }
  }

  Future<void> _removeItem(int id, int idUser) async {
    bool response = await _trolleyNetwork.removeTrolley(id);
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success  deleted')));
      _refreshTrolley(idUser);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fall Delete Data $id')));
    }
  }

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

  void _incrementCount(bool isSelected, item) {
    setState(() {
      item.qty++;
      if (isSelected) calculateTotalPrice();
    });
  }

  void _decrementCount(bool isSelected, item) {
    setState(() {
      if (item.qty > 1) {
        item.qty--;
        if (isSelected) calculateTotalPrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Text('Total Price: \$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Checkout Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
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
      appBar: AppBar(leading: const BackButton(), title: const Text('My Trolley')),
      body: FutureBuilder<List<TrolleyModel>>(
        future: _trolleyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your trolley is empty.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                // var item = availableItems[index];
                // var item = snapshot.data![index];
                bool isSelected = cartItems.contains(item);
                itemCounts.putIfAbsent(item.idProduct, () => item.qty);

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
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Price: \$${item.price}',
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
                            Text(item.qty.toString(), style: const TextStyle(fontSize: 16)),
                            IconButton(
                              iconSize: 20,
                              onPressed: () {
                                _incrementCount(isSelected, item);
                              },
                              icon: const Icon(Icons.add, size: 20),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => _removeItem(item.idTrolley, item.idUser),
                        ),
                      ],
                    ),
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
