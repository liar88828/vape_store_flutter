import 'package:flutter/material.dart';
import 'package:vape_store/assets/favorite_example.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/screen/detail_screen.dart';

class FavoriteDetailScreen extends StatelessWidget {
  const FavoriteDetailScreen({
    super.key,
    required this.id,
  });
  final int id;

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
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return ListTile(
            leading: Image.asset(
              favorite.img,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(favorite.title),
            subtitle: Text('Items: ${favorite.item}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle the tap event, e.g., navigate to a details page
              // print('Tapped on ${favorite.title}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            id: favorite.id,
                          )));
            },
          );
        },
      ),
    );
  }
}
