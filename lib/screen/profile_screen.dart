import 'package:flutter/material.dart';
import 'package:vape_store/assets/product_example.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/utils/date.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/widgets/button_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    final List<ProductModel> products = productExample;

    return Scaffold(
      // backgroundColor: colorTheme.primaryContainer,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              color: colorTheme.primary,
              style: IconButton.styleFrom(
                  backgroundColor: colorTheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              // color: Colors.red,
              onPressed: () {},
              icon: const Icon(Icons.trolley),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtonNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/images/profile.png',
                        height: 110,
                        width: 110,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User1 Alex Ganteng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '081-1234-1234-123',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Driver',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      CardStatus(
                        colorTheme: colorTheme,
                        title: 'Total Favorite',
                        count: 20,
                      ),
                      CardStatus(
                        colorTheme: colorTheme,
                        title: 'Total Buy',
                        count: 20,
                      ),
                      // CardStatus(
                      //   colorTheme: colorTheme,
                      //   title: 'Total Buy',
                      //   count: 20,
                      // ),
                      // CardStatus(
                      //   colorTheme: colorTheme,
                      //   title: '',
                      //   count: 0,
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(onPressed: () {}, child: Text('View More'))
                    ]),
                Column(
                  children: products.map((product) {
                    return ProductList(
                      title: product.title,
                      date: product.date,
                      price: product.price,
                      id: product.id,
                    );
                  }).toList(),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.title,
    required this.date,
    required this.price,
    required this.id,
  });
  final String title;
  final DateTime date;
  final int price;
  final int id;

  @override
  Widget build(BuildContext context) {
    final String formattedDate = formatDate(date);
    final formattedPrice = formatPrice(price);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'lib/images/banner1.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedPrice,
                      style: TextStyle(),
                    ),
                    Text(formattedDate,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey)),
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  // id
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(
                                id: 1,
                              )));
                },
                icon: Icon(Icons.arrow_forward))
          ],
        ),
      ),
    );
  }
}

class CardStatus extends StatelessWidget {
  const CardStatus({
    super.key,
    required this.colorTheme,
    required this.title,
    required this.count,
  });

  final ColorScheme colorTheme;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorTheme.primaryContainer,
      child: Container(
        // width: 85,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(title, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
