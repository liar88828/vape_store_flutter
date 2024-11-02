import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _value;
  @override
  Widget build(BuildContext context) {
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                    Text('1'),
                    IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  ],
                ),
              ),
              // SizedBox(width: 25),
              FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: Size(240, 100),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
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
          title: Text('Detail Product'),
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
                icon: Badge(
                  alignment: AlignmentDirectional(3, -2),
                  smallSize: 1,
                  label: Text('1'),
                  child: const Icon(
                    Icons.trolley,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              color: Colors.grey.shade50,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(height: 400.0),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade50),
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Fruit Punch Series',
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 16)),
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries',
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    children: [
                                      Text(
                                        'Rp123.45',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Stock: 10 pcs',
                                        style: TextStyle(color: Colors.black54),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 5.0,
                                      children: ['30 ML', '60 ML', '90 ML']
                                          .map((label) => ChoiceChip(
                                                label: Text(label),
                                                selected: _value == label,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                selectedColor: Colors.grey[400],
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
                                    SizedBox(height: 20),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Description',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.arrow_drop_down))
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries'),
                                          SizedBox(height: 100),
                                        ])
                                  ])
                            ]))
                  ]))
        ])));
  }
}
