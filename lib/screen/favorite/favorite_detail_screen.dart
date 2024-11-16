import 'package:flutter/material.dart';
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/screen/favorite/favorites_screen.dart';
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
  late Future<FavoriteModel> _favoriteData;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _favoriteListData = _favoriteNetwork.fetchFavoritesByListId(widget.id);
    _favoriteData = _favoriteNetwork.fetchFavoriteById(widget.id);
    _refreshData();
  }

  Future<void> _refreshData() async {
    final data = await _favoriteData;
    // ignore: unnecessary_null_comparison
    if (data != null) {
      _titleController.text = data.title;
      _descriptionController.text = data.description;
    }
    setState(() {});
  }

  Future<void> _updateFavorite(context) async {
    try {
      final favorite = FavoriteModel(
        id: widget.id,
        idUser: 0,
        description: _descriptionController.text,
        title: _titleController.text,
      );

      await _favoriteNetwork.updateFavorite(favorite);
      if (context.mounted) {
        Navigator.pop(context, true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
      }
    } catch (e) {
      print(e);
      // Navigator.pop(context);
    }
  }

  Future<void> _deleteFavorite() async {
    // print(widget.id);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  _favoriteNetwork.deleteFavorite(widget.id);
                  // Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                },
              ),
            ],
            title: const Text('Delete Favorite'),
            content: const SingleChildScrollView(
              child: ListBody(children: <Widget>[
                Text('Are you sure you want to delete this favorite?'),
              ]),
            ),
          );
        });
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SizedBox(
    //         height: 200,
    //         child: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Text('Modal Sheet'),
    //               ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: const Text('Delete'),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  Future<void> _editFavorite() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Edit'),
                onPressed: () async {
                  await _updateFavorite(context);
                  // Navigator.of(context).pop();
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                },
              ),
            ],
            title: const Text('Edit'),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                const Text('Are you sure you want to delete this favorite?'),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    // final List<FavoriteModel> favorites = favoriteExample;

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                )),
          ),
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
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ))),
          actions: [
            IconButton(
                color: colorTheme.primary,
                style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                // color: Colors.red,
                onPressed: _editFavorite,
                icon: const Icon(
                  Icons.edit,
                )),
            IconButton(
                color: colorTheme.primary,
                style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                // color: Colors.red,
                onPressed: _deleteFavorite,
                icon: const Icon(
                  Icons.delete,
                )),
            const SizedBox(width: 5)
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
