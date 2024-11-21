import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vape_store/bloc/counter/counter_bloc.dart';
import 'package:vape_store/bloc/product/product_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/screen/checkout/order_screen.dart';
import 'package:vape_store/screen/favorite/favorite_detail_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;
  final String redirect;
  final int lastId;
  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.redirect,
    required this.lastId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FavoriteNetwork _favoriteNetwork = FavoriteNetwork();
  late Future<ProductModel> _productData;
  late Future<List<FavoriteModel>> _favoriteData;

  UserModel? _userData;

  void _selectType(String label) {
    context.read<ProductBloc>().add(ProductTypeEvent(type: label));
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(ProductDetailEvent(id: widget.id));
    var colorTheme = Theme.of(context).colorScheme;
    void increment() {
      context.read<CounterBloc>().add(IncrementCounterEvent());
    }

    void decrement(state) {
      if (state > 1) {
        context.read<CounterBloc>().add(DecrementCounterEvent());
      }
    }

    void addTrollyApi(int counter, String type) {
      if (type.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Add type ')));
        Navigator.pop(context);
      } else {
        final trolley = TrolleyCreate(
          id: 1,
          qty: counter,
          idProduct: widget.id,
          idUser: _userData!.id,
          type: type,
        );
        context.read<TrolleyBloc>().add(TrolleyAddEvent(trolley: trolley));
      }
    }

    Future<void> addFavorite(FavoriteModel data) async {
      final response = await _favoriteNetwork.addFavoriteList(FavoriteListCreate(
        idFavorite: data.id,
        idProduct: widget.id,
        // idUser: _userData!.id,
      ));
      // print(response.success);
      if (context.mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
        }
      }
    }

    Future<void> showAddFavorite(int counter, String type) {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<List<FavoriteModel>>(
                    future: _favoriteData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('No Favorite found.'));
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Add Favorite', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            const Text('Are you sure you want to add this product to your trolley?'),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    final data = snapshot.data![index];
                                    return ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      tileColor: colorTheme.primaryContainer,
                                      title: Text(data.title),
                                      subtitle: Text(data.description),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          await addFavorite(data);
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 10),
                                FilledButton(
                                  onPressed: () {
                                    addTrollyApi(counter, type);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    }),
              ),
            );
          });
    }

    Future<void> showAddTrolley(int counter, String type) {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      const Text('Add Trolley', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      const Text('Are you sure you want to add this product to your trolley?'),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Wrap(
                            spacing: 5.0,
                            children: ['30 ML', '60 ML', '90 ML']
                                .map((label) => ChoiceChip(
                                    label: Text(label),
                                    selected: type == label,
                                    backgroundColor: colorTheme.surfaceBright,
                                    selectedColor: colorTheme.primaryContainer,
                                    onSelected: (bool selected) {
                                      _selectType(label);
                                    }))
                                .toList())
                      ]),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Qty',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Card(
                              elevation: 0,
                              color: colorTheme.primaryContainer,
                              child: BlocSelector<CounterBloc, CounterState, int>(
                                selector: (stateProduct) => stateProduct.counter,
                                builder: (context, stateProduct) {
                                  return Row(children: [
                                    IconButton(
                                      onPressed: () => decrement(stateProduct),
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      stateProduct.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => increment(),
                                      icon: const Icon(Icons.add),
                                    ),
                                  ]);
                                },
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () {
                              addTrollyApi(counter, type);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      )
                    ]),
                  ),
                );
              },
            );
          });
    }

    Future<void> addCheckout(ProductModel product, int counterQty, String type) async {
      if (type.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please Add Type'),
        ));
        Navigator.pop(context);
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderScreen(
            productTrolley: [
              TrolleyModel(
                  trolleyQty: counterQty,
                  category: type,
                  id: 0,
                  description: '',
                  name: product.name,
                  price: product.price,
                  qty: counterQty,
                  idUser: _userData!.id,
                  type: type,
                  trolleyIdUser: _userData!.id,
                  idProduct: product.id!,
                  idTrolley: 0,
                  idCheckout: 0,
                  createdAt: null,
                  updatedAt: null)
            ],
          );
        }));
      }
    }

    Future<void> toCheckout(ProductModel product, int counter, String type) async {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                          const Text('Add Checkout', style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          const Text('Are you sure you want to add this product to your checkout?'),
                          const SizedBox(height: 10),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('Type',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            Wrap(
                                spacing: 5.0,
                                children: ['30 ML', '60 ML', '90 ML']
                                    .map((label) => ChoiceChip(
                                        label: Text(label),
                                        selected: type == label,
                                        backgroundColor: colorTheme.surfaceBright,
                                        selectedColor: colorTheme.primaryContainer,
                                        onSelected: (bool selected) {
                                          _selectType(label);
                                        }))
                                    .toList())
                          ]),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Card(
                                elevation: 0,
                                color: colorTheme.primaryContainer,
                                child: Row(
                                  children: [
                                    IconButton(onPressed: () => decrement(counter), icon: const Icon(Icons.remove)),
                                    Text(
                                      counter.toString(),
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(onPressed: () => increment(), icon: const Icon(Icons.add)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 10),
                              FilledButton(
                                onPressed: () {
                                  addCheckout(product, counter, type);
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          )
                        ])));
              },
            );
          });
    }

    return BlocSelector<CounterBloc, CounterState, int>(
      selector: (stateCounter) => stateCounter.counter,
      builder: (context, stateCounter) {
        return BlocSelector<ProductBloc, ProductState, String>(
          selector: (stateProduct) {
            return stateProduct.type;
          },
          builder: (context, type) {
            return Scaffold(
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          fixedSize: const Size.square(60),
                          backgroundColor: colorTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => showAddFavorite(stateCounter, type),
                        icon: const Icon(Icons.favorite),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          fixedSize: const Size.fromHeight(100),
                          backgroundColor: colorTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => showAddTrolley(stateCounter, type),
                        child: const Text(
                          'ADD TO TROLLEY',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          fixedSize: const Size.fromHeight(100),
                          backgroundColor: colorTheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          toCheckout(await _productData, stateCounter, type);
                        },
                        child: const Text(
                          'CHECKOUT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Add an empty Spacer here to push the content to the left and right edges
                    ],
                  ),
                ),
                appBar: AppBar(
                  toolbarHeight: 70,
                  leading: BackButton(onPressed: () {
                    if (widget.redirect == 'home') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    } else if (widget.redirect == 'favorite') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavoriteDetailScreen(id: widget.lastId)));
                    } else if (widget.redirect == 'trolley') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                    } else if (widget.redirect == 'search') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    }
                  }),
                  centerTitle: true,
                  title: const Text('Detail Product'),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: BlocSelector<TrolleyBloc, TrolleyState, int>(
                          selector: (stateTrolley) {
                            return stateTrolley.count ?? 0;
                          },
                          builder: (context, stateTrolley) {
                            return IconButton(
                                color: colorTheme.primary,
                                style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                // color: Colors.red,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const TrolleyScreen();
                                  }));
                                },
                                icon: Badge(
                                    // alignment: const AlignmentDirectional(3, -2),
                                    // alignment: const AlignmentDirectional(3, -2),
                                    // smallSize: 1,
                                    label: Text(stateTrolley.toString()),
                                    child: const Icon(
                                      Icons.trolley,
                                    )));
                          },
                        ))
                  ],
                ),
                body: BlocListener<TrolleyBloc, TrolleyState>(
                  listener: (context, stateTrolley) {
                    if (stateTrolley is TrolleyCaseState) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('success ')));
                      Navigator.pop(context);
                    } else if (stateTrolley is TrolleyErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateTrolley.message)));
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(height: 400.0),
                              items: [1, 2, 3, 4, 5].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(horizontal: 1),
                                      decoration: BoxDecoration(color: colorTheme.surfaceBright),
                                      child: Image.asset(
                                        'lib/images/banner1.png',
                                        height: 400,
                                        width: 300,
                                        // fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            BlocBuilder<ProductBloc, ProductState>(
                              buildWhen: (previous, current) {
                                // final product = previous.product != current.product;
                                final type = previous.type == current.type;
                                return //product &&
                                    type;
                              },
                              builder: (context, state) {
                                if (state is ProductLoadingState) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is ProductErrorState) {
                                  return Text("data error : ${state.message}");
                                } else if (state is ProductLoadState) {
                                  final product = state.product;
                                  return Container(
                                      color: Colors.white10,
                                      padding: const EdgeInsets.all(30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(product.name,
                                                        style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ),
                                                  Text(formatPrice(product.price),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey[700],
                                                      ))
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text('brand ${product.brand}',
                                                        textAlign: TextAlign.end,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.purple,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                  ),
                                                  Text(
                                                    "Stock : ${product.qty}",
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Icon(Icons.star, color: Colors.yellow),
                                                      Text('4.7',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            product.description,
                                            softWrap: true,
                                            textAlign: TextAlign.justify,
                                            maxLines: 5,
                                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            const Text('Option', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            const SizedBox(height: 10),
                                            Wrap(
                                              spacing: 5.0,
                                              children: ['30 ML', '60 ML', '90 ML']
                                                  .map((label) => ChoiceChip(
                                                        label: Text(label),
                                                        selected: type == label,
                                                        backgroundColor: colorTheme.surfaceBright,
                                                        selectedColor: colorTheme.primaryContainer,
                                                        onSelected: (bool selected) {
                                                          _selectType(label);
                                                        },
                                                      ))
                                                  .toList(),
                                            ),
                                          ])
                                        ],
                                      ));
                                } else {
                                  return const Text('error');
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}
