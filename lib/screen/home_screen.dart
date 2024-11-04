import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/assets/product_example.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/widgets/button_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<ProductModel> products = productExample;

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    var colorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: colorTheme,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  isDense: true,
                  // contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
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
              icon: const Icon(
                Icons.trolley,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtonNavigation(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            // const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(height: 220),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: colorTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            const Text("SUMMER SALE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                )),
                            const Text("40% OFF",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2)),
                            const SizedBox(height: 20),
                            FilledButton(
                                style: FilledButton.styleFrom(
                                  iconColor: colorTheme.primary,
                                  backgroundColor: colorTheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Row(children: [
                                  Text(
                                    'EXPLORE',
                                    style: TextStyle(
                                        // color: Colors.white
                                        ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    // color: colorTheme.primary,
                                    color: Colors.deepPurple,
                                  )
                                ])),
                          ]),
                          Image.asset('lib/images/banner1.png',
                              width: 100, height: 120, fit: BoxFit.cover)
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorTheme.primaryContainer,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20), // Uniform radius
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ProductList(heightScreen: heightScreen, products: products),
                  const SizedBox(height: 20),
                  ProductFlashSale(
                      heightScreen: heightScreen, products: products),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.heightScreen,
    required this.products,
  });

  final double heightScreen;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'View More',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
        SizedBox(
          height: heightScreen / 4.5, // Define a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailScreen(
                          id: product.id,
                        );
                      }));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              product.img,
                              height: 120,
                              width: 120,
                              // fit: BoxFit.fill
                            ),
                            const Positioned(
                              top: 1,
                              right: 1,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          product.title,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatPrice(product.price),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductFlashSale extends StatelessWidget {
  const ProductFlashSale({
    super.key,
    required this.heightScreen,
    required this.products,
  });

  final double heightScreen;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Flash Sale',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'View More',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
        SizedBox(
          height: heightScreen / 4.5, // Define a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                              id: product.id,
                            ))),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              product.img,
                              height: 120,
                              width: 120,
                              // fit: BoxFit.fill
                            ),
                            const Positioned(
                              top: 1,
                              right: 1,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          product.title,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatPrice(product.price),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
