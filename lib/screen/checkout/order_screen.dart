import 'package:flutter/material.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/utils/money.dart';

class OrderScreen extends StatelessWidget {
  final List<TrolleyModel>? productTrolley;
  const OrderScreen({super.key, required this.productTrolley});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    // print(productModel.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text('Order Screen'),
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: BackButton(),
        ),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Text('CHECKOUT (RP 123.456)')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ListCheckout(
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
                TrolleyProductCard(
                  colorTheme: colorTheme,
                  product: productTrolley![0],
                ),
              ],
            ),
            ListCheckout(
              colorTheme: colorTheme,
              text: 'Delivery',
              onClick: () {},
              subtitle: formatPrice(20000000),
              title: "JNT",
              icon: Icons.delivery_dining,
            ),
            ListCheckout(
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

  Row TrolleyProductCard({
    required ColorScheme colorTheme,
    required TrolleyModel product,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Card(
                child: Image.asset(
              'lib/images/banner1.png',
              height: 100,
              width: 100,
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
                  'Option : ${product.option}',
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: colorTheme.errorContainer,
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: colorTheme.error,
                )),
            const SizedBox(height: 5),
            Row(
              children: [
                Text("Qty : ${product.qty}"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column ListCheckout({
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
        contentPadding: EdgeInsets.all(0),
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

// Card(
//                   child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(children: [
//                         Image.asset('lib/images/banner1.png', height: 50, width: 50),
//                         const Text(
//                           'Gopay',
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         const Text('Rp 123.456'),
//                       ])))
