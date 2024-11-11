import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/assets/product_example.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/product_network.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/utils/pref_user.dart';
import 'package:vape_store/widgets/button_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final List<ProductModel> products = productExample;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiTrolley = TrolleyNetwork();
  final _apiProduct = ProductNetwork();

  int? _trolleyCount;
  late UserModel? _userData;
  late Future<List<ProductModel>> _newProducts;
  late Future<List<ProductModel>> _flashSaleProducts;

  // late Future<List<ProductModel>> favoriteProducts;
  // late Future<List<ProductModel>> favoriteProducts;

  // Helper function to load user data and initialize countTrolley
  Future<void> _storeUserData() async {
    _userData = await loadUserData();
    if (_userData != null) {
      int count = await _apiTrolley.fetchTrolleyCount(_userData!.id);
      // print(userData?.toJson());
      setState(() {
        _trolleyCount = count;
      }); // Trigger a rebuild when userData and countTrolley are ready
    }
  }

  @override
  void initState() {
    super.initState();
    _storeUserData(); // Load user data and set countTrolley
    // favoriteProducts = apiProduct.fetchProductsFavorite();
    _newProducts = _apiProduct.fetchProductsNewProduct();
    _flashSaleProducts = _apiProduct.fetchProductsFlashSale();
  }

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    var colorTheme = Theme.of(context).colorScheme;

    // print(countTrolley);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
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
              icon: Badge(
                isLabelVisible: true,
                label: Text(_trolleyCount?.toString() ?? "0"),
                child: const Icon(Icons.trolley),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ButtonNavigation(),
      body: SingleChildScrollView(
        // padding: EdgeInsets.only(top: 20),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorTheme.primaryContainer,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20), // Uniform radius
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  FutureBuilder<List<ProductModel>>(
                      future: _newProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return ProductList(
                            title: 'New Products',
                            heightScreen: heightScreen,
                            products: snapshot.data!,
                            colorTheme: colorTheme,
                          );
                        }
                      }),
                  const SizedBox(height: 20),
                  FutureBuilder<List<ProductModel>>(
                      future: _newProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return ProductList(
                            title: 'Flash Sale',
                            heightScreen: heightScreen,
                            products: snapshot.data!,
                            colorTheme: colorTheme,
                          );
                        }
                      }),
                  // ProductFlashSale(
                  //     heightScreen: heightScreen,
                  //     products: HomeScreen.products),
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
    required this.title,
    required this.colorTheme,
  });

  final double heightScreen;
  final List<ProductModel> products;
  final String title;
  final ColorScheme colorTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
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
          height: heightScreen / 4.1, // Define a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(id: product.id ?? 0))),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  child: Container(
                    width: 150,
                    // height: 500,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              'lib/images/banner1.png',
                              // product.img,
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
                          product.name,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatPrice(product.price),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Spacer(),
                            // IconButton(
                            //     style: IconButton.styleFrom(
                            //       backgroundColor: colorTheme.primaryContainer,
                            //     ),
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.trolley)),
                          ],
                        )
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
