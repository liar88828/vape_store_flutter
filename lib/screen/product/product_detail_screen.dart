import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/network/product_network.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/screen/checkout/order_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/utils/pref_user.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.id});
  final int id;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductNetwork _productNetwork = ProductNetwork();
  final TrolleyNetwork _trolleyNetwork = TrolleyNetwork();

  final FavoriteNetwork _favoriteNetwork = FavoriteNetwork();
  late Future<ProductModel> _productData;
  late Future<List<FavoriteModel>> _favoriteData;

  UserModel? _userData;
  String? _valueType = '';
  int? _countTrolley;
  int _counterQty = 1; // Define _counter as part of the widget state

  Future<void> _refreshData() async {
    _userData = await loadUserData();
    if (_userData != null) {
      _countTrolley = await _trolleyNetwork.fetchTrolleyCount(_userData!.id);
      _favoriteData = _favoriteNetwork.fetchFavoritesByUserId(_userData!.id);
      debugPrint(_favoriteData.toString());
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _productData = _productNetwork.fetchProductById(widget.id);
    _refreshData();
  }

  void _increment(setState) {
    setState(() => _counterQty++);
  }

  void _decrement(setState) {
    if (_counterQty > 1) {
      setState(() => _counterQty--);
    }
  }

  Future<void> _addCheckout(ProductModel product) async {
    if (_valueType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Add Type'),
      ));
      Navigator.pop(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderScreen(
          productTrolley: [
            TrolleyModel(
                trolleyQty: _counterQty,
                category: _valueType ?? '',
                id: 0,
                description: '',
                name: product.name,
                price: product.price,
                qty: _counterQty,
                idUser: _userData!.id,
                type: _valueType ?? '',
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

  Future<void> _toCheckout(ColorScheme colorTheme, ProductModel product) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
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
                                    selected: _valueType == label,
                                    backgroundColor: colorTheme.surfaceBright,
                                    selectedColor: colorTheme.primaryContainer,
                                    onSelected: (bool selected) {
                                      _selectType(label, setState);
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
                                IconButton(onPressed: () => _decrement(setState), icon: const Icon(Icons.remove)),
                                Text(
                                  _counterQty.toString(),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                IconButton(onPressed: () => _increment(setState), icon: const Icon(Icons.add)),
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
                              _addCheckout(product);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      )
                    ])));
          });
        });
  }

  Future<void> _addTrolly(BuildContext context) async {
    if (_valueType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Add type ')));
      Navigator.pop(context);
    } else {
      final response = await _trolleyNetwork.addTrolley(
        TrolleyCreate(
          id: 1,
          qty: _counterQty,
          idProduct: widget.id,
          idUser: _userData!.id,
          type: _valueType ?? "",
        ),
      );
      // return response;
      if (context.mounted) {
        if (response) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('success ')));
          Navigator.pop(context);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('fail')));
        }
      }
    }
  }

  Future<void> _showAddTrolley(ColorScheme colorTheme, BuildContext context) {
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
                                  selected: _valueType == label,
                                  backgroundColor: colorTheme.surfaceBright,
                                  selectedColor: colorTheme.primaryContainer,
                                  onSelected: (bool selected) {
                                    _selectType(label, setState);
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
                            child: Row(children: [
                              IconButton(
                                onPressed: () => _decrement(setState),
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                _counterQty.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _increment(setState),
                                icon: const Icon(Icons.add),
                              ),
                            ]))
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
                            _addTrolly(context);
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

  Future<void> _showAddFavorite(
    ColorScheme colorTheme,
    BuildContext context,
  ) {
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
                      // debugPrint('Error: ${snapshot.error}');
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
                                    // contentPadding: EdgeInsets.all(10),
                                    title: Text(data.title),

                                    subtitle: Text(data.description),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () async {
                                        await addFavorite(context, data);
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
                                  _addTrolly(context);
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

  Future<void> addFavorite(
    BuildContext context,
    FavoriteModel data,
  ) async {
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

  void _selectType(String label, setState) {
    setState(() {
      _valueType = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    // final TextTheme textTheme = Theme.of(context).textTheme;
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
                onPressed: () => _showAddFavorite(colorTheme, context),
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
                onPressed: () => _showAddTrolley(colorTheme, context),
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
                  _toCheckout(colorTheme, await _productData);
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: BackButton(
              style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
          centerTitle: true,
          title: const Text('Detail Product'),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
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
                        label: Text(_countTrolley != null ? _countTrolley.toString() : ''),
                        child: const Icon(
                          Icons.trolley,
                        ))))
          ],
        ),
        body: FutureBuilder<ProductModel>(
            future: _productData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                    // padding: EdgeInsets.all(30),
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
                                          child: Text(snapshot.data!.name,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Text(formatPrice(snapshot.data!.price),
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
                                          child: Text('brand ${snapshot.data!.brand}',
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Text(
                                          "Stock : ${snapshot.data!.qty}",
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
                                  snapshot.data!.description,
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
                                              selected: _valueType == label,
                                              backgroundColor: colorTheme.surfaceBright,
                                              selectedColor: colorTheme.primaryContainer,
                                              onSelected: (bool selected) {
                                                _selectType(label, setState);
                                              },
                                            ))
                                        .toList(),
                                  ),
                                  // const SizedBox(height: 20),
                                  // Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment
                                  //                 .spaceBetween,
                                  //         children: [
                                  //           const Text('Description',
                                  //               style: TextStyle(
                                  //                   fontWeight:
                                  //                       FontWeight.bold,
                                  //                   fontSize: 16)),
                                  //           IconButton(
                                  //               onPressed: () {},
                                  //               icon: const Icon(Icons
                                  //                   .arrow_drop_down))
                                  //         ],
                                  //       ),
                                  //       const SizedBox(height: 10),
                                  //       Text(snapshot.data!.description),
                                  //       const SizedBox(height: 100),
                                  //     ])
                                ])
                              ],
                            )),
                      ],
                    )
                  ],
                ));
              } else {
                return const Center(child: Text('No products found.'));
              }
            }));
  }
}
