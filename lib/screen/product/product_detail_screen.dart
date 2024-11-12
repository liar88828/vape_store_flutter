import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/user_model.dart';
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
  late Future<ProductModel> _productData;
  String? _value;
  int? _countTrolley;
  int _counter = 1;
  UserModel? _userData;

  void increment() {
    setState(() => _counter++);
  }

  void decrement() {
    setState(() => _counter--);
  }

  Future<void> _addTrolly() async {
    final response = await _trolleyNetwork.addTrolley(
      qty: _counter,
      idProduct: widget.id,
      idUser: _userData!.id,
    );
    // return response;
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('success ')));
      // Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('fail')));
    }
  }

  Future<void> _refreshData() async {
    _userData = await loadUserData();
    if (_userData != null) {
      _countTrolley = await _trolleyNetwork.fetchTrolleyCount(_userData!.id);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _productData = _productNetwork.fetchProductById(widget.id);
    _refreshData();
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
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: decrement, icon: const Icon(Icons.remove)),
                    Text(
                      _counter.toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: increment, icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: const Size(240, 100),
                  backgroundColor: colorTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await _addTrolly();
                },
                child: const Text(
                  'ADD TO TROLLEY',
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
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No products found.'));
              } else {
                return SingleChildScrollView(
                    // padding: EdgeInsets.all(30),
                    child: Column(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rasa Anggur', style: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  Text('4.7', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          ),
                          Text(snapshot.data!.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          Row(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  snapshot.data!.description,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  maxLines: 5,
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatPrice(snapshot.data!.price),
                                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "qty : ${snapshot.data!.qty}",
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              )
                            ],
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
                                        selected: _value == label,
                                        backgroundColor: colorTheme.surfaceBright,
                                        selectedColor: colorTheme.surface,
                                        onSelected: (selected) {
                                          setState(() {
                                            _value = label;
                                            debugPrint(_value);
                                            var data = _value == label;
                                            debugPrint(data.toString());
                                          });
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
                        ]))
                  ])
                ]));
              }
            }));
  }
}
