import 'package:flutter/material.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/widgets/button_navigation.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    final List<ProductModel> products = [
      ProductModel(
        title: 'Product 1',
        date: DateTime.now(),
        price: 100000,
        id: 1,
      ),
      ProductModel(
        title: 'Product 2',
        date: DateTime.now(),
        price: 200000,
        id: 2,
      ),
      ProductModel(
        title: 'Product 3',
        date: DateTime.now(),
        price: 150000,
        id: 3,
      ),
      ProductModel(
        title: 'Product 4',
        date: DateTime.now(),
        price: 250000,
        id: 4,
      ),
      ProductModel(
        title: 'Product 234',
        date: DateTime.now(),
        price: 250000,
        id: 5,
      ),
      ProductModel(
        title: 'Product 234',
        date: DateTime.now(),
        price: 250000,
        id: 6,
      ),
      ProductModel(
        title: 'Product 234',
        date: DateTime.now(),
        price: 250000,
        id: 36,
      ),
      ProductModel(
        title: 'Product 234',
        date: DateTime.now(),
        price: 250000,
        id: 635,
      ),
    ];

    return Scaffold(
      // backgroundColor: colorTheme.primaryContainer,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
              decoration: InputDecoration(
                  // fillColor: Colors.white,
                  // focusColor: Colors.white,
                  isDense: true,
                  // contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    // borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)))),
        ),
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
    final String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price);

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailScreen()));
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
