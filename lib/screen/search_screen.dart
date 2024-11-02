import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Anggur',
      'price': 'Rp 210.000'
    },
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Anggur',
      'price': 'Rp 210.000'
    },
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Anggur',
      'price': 'Rp 210.000'
    },
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Anggur',
      'price': 'Rp 210.000'
    },
    {
      'image': 'lib/images/banner1.png',
      'title': 'Vape Rasa Anggur',
      'price': 'Rp 210.000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
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
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.search)))),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                // color: Colors.red,
                onPressed: () {},
                icon: const Icon(
                  Icons.trolley,
                )),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    // color: Colors.red,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.filter_list,
                    )),
                DropdownButtonExample(list: [
                  'Low Price',
                  'Medium Price',
                  'High Price',
                  'Premium'
                ]),
                DropdownButtonExample(list: [
                  'Low Price',
                  'Medium Price',
                  'High Price',
                  'Premium'
                ]),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              primary: false,
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              children: products.map((product) {
                return ProductCard(
                    image: product['image']!,
                    price: product['price']!,
                    title: product['title']!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const ProductCard(
      {super.key,
      required this.image,
      required this.title,
      required this.price});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => DetailScreen()),
        // );
      },
      child: Card(
        // margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        image,

                        height: 150,
                        width: 150,
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
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  final List<String> list;

  const DropdownButtonExample({super.key, required this.list});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  // Initialize dropdownValue with the first item or a default value
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    if (widget.list.isNotEmpty) {
      dropdownValue = widget.list[0]; // Set default value from the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 10,

        style: const TextStyle(color: Colors.deepPurple), // Text color
        underline: Container(), // Optional: to remove the underline
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
