import 'package:flutter/material.dart';
import 'package:vape_store/assets/favorite_example.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/screen/favorite_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    final List<FavoriteModel> favorites = favoriteExample;

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
                color: colorTheme.primary,
                style: IconButton.styleFrom(
                    backgroundColor: colorTheme.primaryContainer,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total : ${favorites.length}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    color: colorTheme.primary,
                    style: IconButton.styleFrom(
                        backgroundColor: colorTheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    icon: const Row(
                      children: [
                        Text('Add'),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                  // SizedBox(width: 12),
                ]),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              primary: false,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              children: favorites.map((favorite) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteDetailScreen(
                                  id: favorite.id,
                                )));
                  },
                  child: Card(
                    key: Key(favorite.id.toString()),
                    color: colorTheme.onPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Image.asset(favorite.img,
                                  height: 150, width: 150)),
                          SizedBox(height: 10),
                          Text(
                            favorite.title,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text("Item : ${favorite.item.toString()}")
                        ],
                      ),
                    ),
                  ),
                );
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
    var colorTheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => DetailScreen()),
        // );
      },
      child: Card(
        color: colorTheme.onPrimary,
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
    var colorTheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: colorTheme.onPrimary,
        border: Border.all(color: colorTheme.primaryContainer),
        borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        dropdownColor: colorTheme.onPrimary,
        elevation: 10,
        style: const TextStyle(), // Text color
        underline: Container(), // Optional: to remove the underline
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: TextStyle(
                  color: colorTheme.primary,
                  fontWeight: FontWeight.bold,
                  // fontSize: 16
                )),
          );
        }).toList(),
      ),
    );
  }
}
