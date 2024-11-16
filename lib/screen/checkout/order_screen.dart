import 'package:flutter/material.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/checkout_network.dart';
import 'package:vape_store/screen/checkout/detail_checkout_screen.dart';
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
  UserModel? _userData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    _userData = await loadUserData();
    if (_userData != null) {}

    setState(() {});
  }

  Future<void> _createCheckout(BuildContext context, CheckoutModel checkout, List<TrolleyModel> trolley) async {
    // print(checkout.toJson());
    // print(trolley.map((e) => e.toJson()).toList());
    final response = await _checkoutNetwork.createCheckout(
      checkout,
      trolley.map((d) => d.id!).toList(),
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
              _createCheckout(
                  context,
                  CheckoutModel(
                    idUser: _userData!.id,
                    total: 1,
                    deliveryMethod: 'jnt',
                    paymentMethod: 'mandiri',
                    paymentPrice: 100,
                    deliveryPrice: 200,
                  ),
                  widget.productTrolley?.toList() ?? []);
            },
            child: const Text('CHECKOUT (RP 123.456)')),
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
                      : widget.productTrolley!.map(
                          (product) {
                            return trolleyProductCard(
                              colorTheme: colorTheme,
                              product: product,
                            );
                          },
                        ).toList(),
                )
              ],
            ),
            listCheckout(
              colorTheme: colorTheme,
              text: 'Delivery',
              onClick: () {},
              subtitle: formatPrice(20000000),
              title: "JNT",
              icon: Icons.delivery_dining,
            ),
            listCheckout(
              colorTheme: colorTheme,
              text: 'Payment Method',
              onClick: () {},
              subtitle: '1234-1234-1234-1234',
              title: "Mandiri",
              icon: Icons.money,
            ),
            const SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Order Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorTheme.primary)),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Subtotal : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Text('Rp 123.456', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[500]))
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Shipping Cost : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Text('+ Rp 123.456', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[500]))
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Discount : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Text('- Rp 123.456', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[500]))
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Text('Rp 123.456', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[700]))
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

  Column listCheckout({
    required ColorScheme colorTheme,
    required String text,
    required String title,
    required String subtitle,
    required Function onClick,
    required IconData icon,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        title: Text(title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            )),
        subtitle: Text(subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            )),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
        ),
      ),
    ]);
  }
}
