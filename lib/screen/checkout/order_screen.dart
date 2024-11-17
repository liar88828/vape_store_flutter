import 'package:flutter/material.dart';
import 'package:vape_store/models/bank_model.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/delivery_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/bank_network.dart';
import 'package:vape_store/network/checkout_network.dart';
import 'package:vape_store/network/delivery_network.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/utils/pref_user.dart';

class OrderScreen extends StatefulWidget {
  final List<TrolleyModel>? productTrolley;
  const OrderScreen({super.key, required this.productTrolley});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final CheckoutNetwork _checkoutNetwork = CheckoutNetwork();
  final BankNetwork _bankNetwork = BankNetwork();
  final DeliveryNetwork _deliveryNetwork = DeliveryNetwork();

  UserModel? _userData;
  Future<List<DeliveryModel>>? _deliveryList;
  Future<List<BankModel>>? _bankList;
  DeliveryModel? _deliveryData;
  BankModel? _bankData;

  OrderInfoModel _totalModel = OrderInfoModel(
    discountPrice: 0,
    shippingCost: 0,
    subTotal: 0,
    total: 0,
    discount: 0,
  );

  @override
  void initState() {
    super.initState();
    _refreshData();
    _deliveryList = _deliveryNetwork.fetchDelivery();
    _bankList = _bankNetwork.fetchBanks();
    _setOrderInfo();
  }

  void _setOrderInfo() {
    // Ensure `trolley` is a list and handle null safety
    final trolley = widget.productTrolley?.toList() ?? [];

    // Calculate the subtotal from the trolley items
    final subtotal = _calculateTotal(
      trolley,
      0, // Initial value
    );

    // Calculate the shipping price
    num shippingPrice = _deliveryData?.price ?? 0;

    // Add shipping cost to subtotal
    final totalBeforeDiscount = subtotal + shippingPrice;

    // Define discount as a percentage (e.g., 10%)
    const discountPercentage = 10;
    num discount = (totalBeforeDiscount * discountPercentage) / 100;

    // Calculate the total after applying the discount
    final afterDiscount = totalBeforeDiscount - discount;

    final data = OrderInfoModel(
      subTotal: subtotal,
      shippingCost: shippingPrice,
      discount: discountPercentage,
      discountPrice: discount,
      total: afterDiscount,
    );
    setState(() {
      _totalModel = data;
    });
  }

  Future<void> _refreshData() async {
    _userData = await loadUserData();
    if (_userData != null) {}
    setState(() {});
  }

  num _calculateTotal(List<TrolleyModel> trolley, num initial) {
    return trolley.fold(
      initial,
      (value, element) => value + (element.trolleyQty * element.price),
    );
  }

  Future<void> _createCheckout(BuildContext context) async {
    List<TrolleyModel> trolley = widget.productTrolley?.toList() ?? [];
    List<int> idTrolley = trolley.map((d) => d.id!).toList();
    num total = _calculateTotal(
      trolley,
      _deliveryData?.price ?? 0,
    );
    CheckoutModel checkout = CheckoutModel(
      idUser: _userData!.id,
      total: total,
      deliveryMethod: _deliveryData?.name ?? '',
      paymentMethod: _bankData?.name ?? '',
      paymentPrice: 100,
      deliveryPrice: _deliveryData?.price ?? 0,
    );

    final response = await _checkoutNetwork.createCheckout(
      checkout,
      idTrolley,
    );
    // print(response);
    if (context.mounted) {
      if (response.success) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailCheckoutScreen(checkout: checkout)));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  void _removeData(int id) {
    setState(() {
      widget.productTrolley?.removeWhere((item) => item.idProduct == id);
    });
    // print(widget.productTrolley?.toList());
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    // print(productModel.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text('Order Screen'),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return const TrolleyScreen();
            }),
          );
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
          style: FilledButton.styleFrom(
            fixedSize: const Size(240, 100),
            backgroundColor: colorTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            _createCheckout(context);
          },
          child: Text('CHECKOUT ${formatPrice(_totalModel.total)}'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            listCheckout(
              colorTheme: colorTheme,
              text: 'My Location',
              onClick: () {},
              subtitle: 'Jl Simongan 63 RT 005/008',
              title: 'Jl Kedungjati 12, Jawa Tengah',
              icon: Icons.payment,
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorTheme.primary,
                    )),
                Column(
                  children: widget.productTrolley == null
                      ? [const Text('Data is null')]
                      : widget.productTrolley!.map((product) {
                          return trolleyProductCard(
                            colorTheme: colorTheme,
                            product: product,
                          );
                        }).toList(),
                )
              ],
            ),
            listCheckout(
              colorTheme: colorTheme,
              text: 'Delivery',
              subtitle: _deliveryData?.price != null ? formatPrice(_deliveryData?.price ?? 0) : null,
              title: _deliveryData?.name,
              icon: Icons.delivery_dining,
              onClick: () {
                showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text('Delivery Method'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          _deliveryData != null
                              ? Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      // tileColor: colorTheme.primaryContainer,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(_deliveryData!.name),
                                      subtitle: Text(formatPrice(_deliveryData!.price)),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _deliveryData = null;
                                          });
                                          _setOrderInfo();

                                          Navigator.pop(context); // Close the dialog after selection
                                        },
                                        icon: const Icon(Icons.check_box),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text('Please Select Delivery Method'),
                          FutureBuilder<List<DeliveryModel>>(
                              future: _deliveryList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(child: Text('Error fetching data'));
                                } else if (snapshot.hasData) {
                                  return Column(
                                    children: snapshot.data!.where((data) {
                                      return data.id != _deliveryData?.id;
                                    }).map((data) {
                                      return ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                        title: Text(data.name),
                                        subtitle: Text(formatPrice(data.price)),
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _deliveryData = data;
                                            });
                                            _setOrderInfo();

                                            Navigator.pop(context); // Close the dialog after selection
                                          },
                                          icon: const Icon(Icons.check_box_outline_blank),
                                        ),
                                      );
                                    }).toList(), // Convert to a list of widgets
                                  );
                                } else {
                                  return const Center(child: Text('No data available'));
                                }
                              }),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Back')),
                    ],
                  ),
                );
              },
            ),
            listCheckout(
              colorTheme: colorTheme,
              text: 'Payment Method',
              title: _bankData?.name,
              subtitle: _bankData?.accounting,
              icon: Icons.money,
              onClick: () {
                showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text('Payment Method'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          _bankData != null
                              ? Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      // tileColor: colorTheme.primaryContainer,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(_bankData!.name),
                                      subtitle: Text(_bankData!.accounting),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _bankData = null;
                                          });
                                          _setOrderInfo();

                                          Navigator.pop(context); // Close the dialog after selection
                                        },
                                        icon: const Icon(Icons.check_box),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text('Please Select Payment Method'),
                          FutureBuilder<List<BankModel>>(
                              future: _bankList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(child: Text('Error fetching data'));
                                } else if (snapshot.hasData) {
                                  return Column(
                                    children: snapshot.data!.map((data) {
                                      return ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                        title: Text(data.name),
                                        subtitle: Text(data.accounting),
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _bankData = data;
                                            });
                                            _setOrderInfo();

                                            Navigator.pop(context); // Close the dialog after selection
                                          },
                                          icon: const Icon(Icons.check_box_outline_blank),
                                        ),
                                      );
                                    }).toList(), // Convert to a list of widgets
                                  );
                                } else {
                                  return const Center(child: Text('No data available'));
                                }
                              }),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Back')),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Order Info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorTheme.primary,
                    )),
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      )),
                  Text(
                    formatPrice(_totalModel.subTotal),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              Column(
                children: widget.productTrolley == null
                    ? [const Text('Data is null')]
                    : widget.productTrolley!.map(
                        (product) {
                          return trolleyProductTotal(
                            colorTheme: colorTheme,
                            product: product,
                          );
                        },
                      ).toList(),
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Shipping Cost : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )),
                Text(formatPrice(_totalModel.shippingCost),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ))
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Discount : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${_totalModel.discount}%",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        )),
                    Text("- ${formatPrice(_totalModel.discountPrice)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorTheme.error,
                        ))
                  ],
                ),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )),
                Text(formatPrice(_totalModel.total),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ))
              ])
            ]),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget trolleyProductCard({
    required ColorScheme colorTheme,
    required TrolleyModel product,
  }) {
    // return ListTile(
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    //   leading: Image.asset(
    //     'lib/images/banner1.png',
    //     height: 80,
    //     width: 80,
    //   ),
    //   title: Text(product.name),
    //   subtitle: Text(formatPrice(product.price)),
    //   trailing: IconButton(
    //     style: IconButton.styleFrom(
    //       backgroundColor: colorTheme.errorContainer,
    //     ),
    //     onPressed: () {},
    //     icon: Icon(Icons.delete, color: colorTheme.error),
    //   ),
    // );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Card(
                child: Image.asset(
              'lib/images/banner1.png',
              height: 70,
              width: 70,
            )),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Type : ${product.type}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
                const SizedBox(height: 10),
                Text(
                  formatPrice(product.price),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: colorTheme.errorContainer,
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {
                  _removeData(product.idProduct);
                  _setOrderInfo();
                },
                icon: Icon(
                  Icons.delete,
                  color: colorTheme.error,
                )),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Qty : ${product.trolleyQty}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget trolleyProductTotal({
    required ColorScheme colorTheme,
    required TrolleyModel product,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const SizedBox(width: 10),
          Text(
            "${product.trolleyQty} x ${product.name} ${formatPrice(product.price)}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
          )
        ]),
        Text(
          formatPrice(product.price * product.trolleyQty),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Column listCheckout({
    required ColorScheme colorTheme,
    required String text,
    required String? title,
    required String? subtitle,
    required Function onClick,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorTheme.primary,
            )),
        // const SizedBox(height: 2),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: IconButton(
              style: IconButton.styleFrom(
                  backgroundColor: colorTheme.primaryContainer,
                  fixedSize: const Size(50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {},
              icon: Icon(icon, color: colorTheme.primary)),
          title: Text(title ?? 'Please Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
          subtitle: Text(subtitle ?? 'Please Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              )),
          trailing: IconButton(
            onPressed: () => onClick(),
            icon: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}
