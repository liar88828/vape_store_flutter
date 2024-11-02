import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/screen/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Map<String, String>> products = [
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Melon',
      'price': 'Rp 200.000'
    },
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Stroberi',
      'price': 'Rp 220.000'
    },
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Anggur',
      'price': 'Rp 210.000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;

    void navigateHandler(int index) {
      switch (index) {
        case 0:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          break;
        case 1:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
          break;
        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
          break;
        case 3:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()))
          break;
        case 4:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()))
          break;
        default:
      }
    }

    return Scaffold(
      backgroundColor: Colors.orangeAccent,
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
              style: IconButton.styleFrom(
                  backgroundColor: Colors.orange,
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
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.orangeAccent,
          unselectedItemColor: Colors.orangeAccent,
          fixedColor: Colors.amberAccent,
          // currentIndex: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (value) => navigateHandler(value),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                // backgroundColor: Colors.amberAccent,
                icon: Icon(Icons.favorite),
                label: 'Favorite'),
            BottomNavigationBarItem(
                // backgroundColor: Colors.redAccent,

                icon: Icon(Icons.search),
                label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ]),
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
                          color: Colors.orange[100],
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
                                  backgroundColor: Colors.orange[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Row(children: [
                                  Text(
                                    'EXPLORE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
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
                color: Colors.orange[800],
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
  final List<Map<String, String>> products;

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
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailScreen();
                      }));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              product['image']!,
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
                          product['title']!,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product['price']!,
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
  final List<Map<String, String>> products;

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
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailScreen())),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
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
                              product['image']!,
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
                          product['title']!,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product['price']!,
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
