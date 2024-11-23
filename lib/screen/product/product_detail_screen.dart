import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vape_store/bloc/auth/auth_bloc.dart';
import 'package:vape_store/bloc/counter/counter_bloc.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/bloc/product/product_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/screen/checkout/order_screen.dart';
import 'package:vape_store/screen/favorite/favorite_detail_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(ProductDetailEvent(id: id));

    void goBackScreen() {
      if (redirect == 'home') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (redirect == 'favorite') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavoriteDetailScreen(idFavorite: lastId)));
      } else if (redirect == 'trolley') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
      } else if (redirect == 'search') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }

    var colorTheme = Theme.of(context).colorScheme;

    void selectType(String label) => context.read<ProductBloc>().add(ProductTypeEvent(type: label));
    void increment() => context.read<CounterBloc>().add(IncrementCounterEvent());
    void decrement() => context.read<CounterBloc>().add(DecrementCounterEvent());
    void goFavoriteCreateScreen(FavoriteModel data) {
      context.read<FavoriteBloc>().add(FavoriteAddListEvent(
              favorite: FavoriteListCreate(
            idFavorite: data.id,
            idProduct: id,
          )));
    }

    void goTrolleyScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const TrolleyScreen();
      }));
    }

    void addTrolleyHandler(String stateProductType, int counter) {
      context.read<TrolleyBloc>().add(TrolleyAddEvent(
            id: 1,
            qty: counter,
            idProduct: id,
            type: stateProductType,
          ));
    }

    Future<void> showAddFavorite(int counter, String type) {
      context.read<FavoriteBloc>().add(FavoriteLoadsEvent());
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, stateFavorite) {
                  if (stateFavorite is FavoriteLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (stateFavorite is FavoriteErrorState) {
                    return Center(child: Text('Error: ${stateFavorite.message}'));
                  } else if (stateFavorite is FavoriteLoadsState) {
                    final favorites = stateFavorite.favorites;
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
                              itemCount: favorites.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final data = favorites[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: colorTheme.primaryContainer,
                                    title: Text(data.title),
                                    subtitle: Text(data.description),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => goFavoriteCreateScreen(data),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 10),
                            // FilledButton(
                            //   onPressed: () {
                            //     addFavoriteApi({counter, type});
                            //     Navigator.pop(context);
                            //   },
                            //   child: const Text('Add'),
                            // ),
                          ],
                        )
                      ],
                    );
                  } else {
                    return const Center(child: Text('No Favorite found.'));
                  }
                }),
              ),
            );
          });
    }

    Future<void> showAddTrolley(int counter) {
      return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocSelector<ProductBloc, ProductState, String>(
            selector: (stateProduct) => stateProduct.type,
            builder: (context, stateProductType) {
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
                                  selected: stateProductType == label,
                                  backgroundColor: colorTheme.surfaceBright,
                                  selectedColor: colorTheme.primaryContainer,
                                  onSelected: (bool selected) {
                                    selectType(label);
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
                                    onPressed: () => decrement(),
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
                          onPressed: () => addTrolleyHandler(stateProductType, counter),
                          child: const Text('Add'),
                        ),
                      ],
                    )
                  ]),
                ),
              );
            },
          );
        },
      );
    }

    Future<void> addCheckout(ProductModel? product, int counterQty, String type, UserModel? user) async {
      if (type.isEmpty || product == null || user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Add Type')));
        Navigator.pop(context);
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return OrderScreen(
              productTrolley: [
                TrolleyModel(
                    trolleyQty: counterQty,
                    category: type,
                    id: 0,
                    description: '',
                    name: product.name,
                    price: product.price,
                    // qty: counterQty,
                    idUser: user.id,
                    type: type,
                    trolleyIdUser: user.id,
                    idProduct: product.id!,
                    idTrolley: 0,
                    idCheckout: 0,
                    createdAt: null,
                    updatedAt: null)
              ],
            );
          },
        ));
      }
    }

    Future<void> toCheckout(ProductModel? product, int counter) async {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return BlocSelector<AuthBloc, AuthState, UserModel?>(
              selector: (state) => state.user,
              builder: (context, stateAuth) {
                return BlocSelector<ProductBloc, ProductState, String>(
                  selector: (stateProduct) => stateProduct.type,
                  builder: (context, stateProductType) {
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
                                            selected: stateProductType == label,
                                            backgroundColor: colorTheme.surfaceBright,
                                            selectedColor: colorTheme.primaryContainer,
                                            onSelected: (bool selected) {
                                              selectType(label);
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
                                        IconButton(onPressed: () => decrement(), icon: const Icon(Icons.remove)),
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
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 10),
                                  FilledButton(
                                    onPressed: () => addCheckout(product, counter, stateProductType, stateAuth),
                                    child: const Text('Add'),
                                  ),
                                ],
                              )
                            ])));
                  },
                );
              },
            );
          });
    }

    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Builder(builder: (context) {
            final counter = context.select((CounterBloc bloc) => bloc.state.counter);
            final productState = context.select((ProductBloc bloc) => bloc.state);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(
                    fixedSize: const Size.square(60),
                    backgroundColor: colorTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => showAddFavorite(counter, productState.type),
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
                  onPressed: () => showAddTrolley(counter),
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
                  onPressed: () => toCheckout(productState.product, counter),
                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Add an empty Spacer here to push the content to the left and right edges
              ],
            );
          }),
        ),
        appBar: AppBar(
          toolbarHeight: 70,
          leading: BackButton(onPressed: () => goBackScreen()),
          centerTitle: true,
          title: const Text('Detail Product'),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: BlocSelector<TrolleyBloc, TrolleyState, int>(
                  selector: (stateTrolley) => stateTrolley.count ?? 0,
                  builder: (context, stateTrolleyCount) {
                    return IconButton(
                        color: colorTheme.primary,
                        style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        // color: Colors.red,
                        onPressed: () => goTrolleyScreen(),
                        icon: Badge(
                            label: Text(stateTrolleyCount.toString()),
                            child: const Icon(
                              Icons.trolley,
                            )));
                  },
                ))
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TrolleyBloc, TrolleyState>(
              listener: (context, stateTrolley) {
                if (stateTrolley is TrolleyCaseState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('success')));
                  Navigator.pop(context);
                }
                if (stateTrolley is TrolleyErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateTrolley.message)));
                }
                if (stateTrolley is TrolleyCaseErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 5),
                    content: Text(stateTrolley.message),
                  ));
                  Navigator.pop(context);
                }
              },
            ),
            BlocListener<FavoriteBloc, FavoriteState>(
              listener: (context, stateDeliveryListener) {
                if (stateDeliveryListener is FavoriteSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateDeliveryListener.message)));
                  Navigator.pop(context);
                } else if (stateDeliveryListener is FavoriteErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateDeliveryListener.message)));
                }
              },
            ),
          ],
          child: BlocBuilder<ProductBloc, ProductState>(
            buildWhen: (previous, current) {
              final type = previous.type == current.type;
              return type || type;
            },
            builder: (context, stateProduct) {
              if (stateProduct is ProductLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateProduct is ProductErrorState) {
                return Text(stateProduct.message);
              } else if (stateProduct is ProductLoadState) {
                final product = stateProduct.product;
                return SingleChildScrollView(
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
                          Container(
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
                                                  ))),
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
                                                  ))
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
                                    const Text('Type : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 10),
                                    BlocSelector<ProductBloc, ProductState, String>(
                                      selector: (stateProductSelector) {
                                        return stateProductSelector.type;
                                      },
                                      builder: (context, stateProductTypeSelector) {
                                        return Wrap(
                                          spacing: 5.0,
                                          children: ['30 ML', '60 ML', '90 ML']
                                              .map((label) => ChoiceChip(
                                                    label: Text(label),
                                                    selected: stateProductTypeSelector == label,
                                                    backgroundColor: colorTheme.surfaceBright,
                                                    selectedColor: colorTheme.primaryContainer,
                                                    onSelected: (bool selected) {
                                                      selectType(label);
                                                    },
                                                  ))
                                              .toList(),
                                        );
                                      },
                                    ),
                                  ])
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return const Text('Something went wrong Bloc Or Api');
              }
            },
          ),
        ));
  }
}
