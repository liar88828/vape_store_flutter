import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/product/product_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/widgets/button_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // context.read<BankBloc>().add(BankFetchEvent());
    // context.read<DeliveryBloc>().add(DeliveryFetchEvent());
    context.read<ProductBloc>().add(ProductNewEvent());

    var heightScreen = MediaQuery.of(context).size.height;
    var colorTheme = Theme.of(context).colorScheme;

    // print(countTrolley);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BlocSelector<TrolleyBloc, TrolleyState, int>(
              selector: (stateTrolley) {
                return stateTrolley.count ?? 0;
              },
              builder: (context, stateTrolleyCount) {
                return IconButton(
                  color: colorTheme.primary,
                  style: IconButton.styleFrom(
                    // backgroundColor: colorTheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // color: Colors.red,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const TrolleyScreen();
                    }));
                  },
                  icon: Badge(
                    isLabelVisible: true,
                    label: Text(stateTrolleyCount.toString()),
                    child: const Icon(Icons.trolley),
                  ),
                );
              },
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
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: colorTheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
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
                            Text("40% OFF",
                                style: TextStyle(
                                  color: colorTheme.primary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                )),
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
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  const Text(
                                    'EXPLORE',
                                    style: TextStyle(
                                        // color: Colors.white
                                        ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    // color: colorTheme.primary,
                                    color: colorTheme.primaryContainer,
                                  ),
                                ])),
                          ]),
                          Image.asset(
                            'lib/images/banner1.png',
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          )
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

                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, stateProductNew) {
                      if (stateProductNew is ProductLoadingState) {
                        return const CircularProgressIndicator();
                      } else if (stateProductNew is ProductErrorState) {
                        return Text(stateProductNew.message);
                      } else if (stateProductNew is ProductNewState) {
                        return ProductList(
                          title: 'New Products',
                          heightScreen: heightScreen,
                          products: stateProductNew.products,
                          colorTheme: colorTheme,
                        );
                      } else {
                        return const Text('Something went wrong Bloc or Api');
                      }
                    },
                  ),

                  BlocBuilder<ProductBloc, ProductState>(
                    // buildWhen: (previous, current) {
                    //   // final products = previous.products == current.products;
                    //   // final product = previous.product == current.product;

                    //   // print('----------');
                    //   // print('products : $products and product : $product');
                    //   // print('----------');
                    //   return true //&& product || type
                    //       ;
                    // },
                    builder: (context, stateProductNew) {
                      if (stateProductNew is ProductLoadingState) {
                        return const CircularProgressIndicator();
                      } else if (stateProductNew is ProductErrorState) {
                        return Text(stateProductNew.message);
                      } else if (stateProductNew is ProductNewState) {
                        return ProductList(
                          title: 'Flash Sale',
                          heightScreen: heightScreen,
                          products: stateProductNew.products,
                          colorTheme: colorTheme,
                        );
                      } else {
                        return const Text('Something went wrong Bloc or Api');
                      }
                    },
                  ),

                  const SizedBox(height: 20),

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
              style: TextStyle(
                color: colorTheme.primary,
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
                        builder: (context) => ProductDetailScreen(
                              id: product.id ?? 0,
                              lastId: 0,
                              redirect: 'home',
                            ))),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  child: Container(
                    width: 150,
                    // height: 500,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
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
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
