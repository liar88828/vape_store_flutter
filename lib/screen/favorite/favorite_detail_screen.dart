import 'package:flutter/material.dart';
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';

class FavoriteDetailScreen extends StatefulWidget {
  const FavoriteDetailScreen({
    super.key,
    required this.id,
  });
  final int id;

  @override
  State<FavoriteDetailScreen> createState() => _FavoriteDetailScreenState();
}

class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
  final FavoriteNetwork _favoriteNetwork = FavoriteNetwork();
  late Future<List<FavoriteListModel>> _favoriteListData;

  @override
  void initState() {
    super.initState();
    _favoriteListData = _favoriteNetwork.fetchFavoritesByListId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    // final List<FavoriteModel> favorites = favoriteExample;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
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
                    suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.search)))),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  color: colorTheme.primary,
                  style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  // color: Colors.red,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.trolley,
                  )),
            ),
          ],
        ),
        body: FutureBuilder(
            future: _favoriteListData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error Data is not found'));
              } else if (snapshot.data!.isEmpty) {
                return const Center(child: Text('Data is Empty'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final favorite = snapshot.data![index];
                    return ListTile(
                      // tileColor: colorTheme.primary,
                      leading: Image.asset(
                        'lib/images/banner1.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        favorite.name!,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        favorite.description!,
                        maxLines: 1,
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Handle the tap event, e.g., navigate to a details page
                        // print('Tapped on ${favorite.title}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                      id: favorite.idProduct!,
                                    )));
                      },
                    );
                  },
                );
              }
            }));
  }
}
