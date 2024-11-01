import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: BottomAppBar(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange[800],
                      border: Border.all(color: Colors.transparent),
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
                  SizedBox(width: 25),
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
                ],
              ),
              // Add an empty Spacer here to push the content to the left and right edges
            ],
          ),
        ),
        appBar: AppBar(
          leading: BackButton(
            style: IconButton.styleFrom(
                // padding: EdgeInsets.all(20),
                // backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          centerTitle: true,
          title: Text('Detail Product'),
          actions: [
            IconButton(
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
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              color: Colors.grey.shade50,
              child: Column(children: [
                Image.asset('lib/images/banner1.png'),
                Container(
                    color: Colors.white10,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          const Text(
                            'Fruit Punch Series',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
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
                            height: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Option',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Row(
                                  children: ['Small', 'Medium', 'Large']
                                      .map((label) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: FilledButton(
                                              style: FilledButton.styleFrom(
                                                  backgroundColor: Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () {},
                                              child: Text(label),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.arrow_drop_down))
                                        ],
                                      ),
                                      Text(
                                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries')
                                    ])
                              ])
                        ]))
              ]))
        ])));
  }
}
