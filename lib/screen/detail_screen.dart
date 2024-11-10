import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vape_store/screen/order_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});

  final int id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _value;
  int _counter = 1;
  void increment() {
    setState(() => _counter++);
  }

  void decrement() {
    setState(() => _counter--);
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
                    IconButton(
                        onPressed: decrement, icon: const Icon(Icons.remove)),
                    Text(
                      _counter.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: increment, icon: const Icon(Icons.add)),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderScreen()));
                },
                child: const Text(
                  'ADD TO CART',
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
              style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          centerTitle: true,
          title: const Text('Detail Product'),
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
                icon: const Badge(
                  alignment: AlignmentDirectional(3, -2),
                  smallSize: 1,
                  label: Text('1'),
                  child: Icon(
                    Icons.trolley,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
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
                      decoration:
                          BoxDecoration(color: colorTheme.surfaceBright),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fruit Punch Series',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text('4.7',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ],
                      ),
                      const Text('Fruit Punch Series',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      const Row(
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries',
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              maxLines: 5,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp123.45',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Stock: 10 pcs',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Option',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 5.0,
                              children: ['30 ML', '60 ML', '90 ML']
                                  .map((label) => ChoiceChip(
                                        label: Text(label),
                                        selected: _value == label,
                                        backgroundColor:
                                            colorTheme.surfaceBright,
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
                            const SizedBox(height: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Description',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      IconButton(
                                          onPressed: () {},
                                          icon:
                                              const Icon(Icons.arrow_drop_down))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries'),
                                  const SizedBox(height: 100),
                                ])
                          ])
                    ]))
          ])
        ])));
  }
}
