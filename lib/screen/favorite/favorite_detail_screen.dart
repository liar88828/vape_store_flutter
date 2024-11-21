import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
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
  late Future<FavoriteModel> _favoriteData;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _favoriteListData = _favoriteNetwork.fetchFavoritesByListId(widget.id);
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

  Future<void> _deleteFavorite(BuildContext context) async {
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
                  context.read<FavoriteBloc>().add(FavoriteDeleteEvent(id: widget.id));
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
                onPressed: () {
                  context.read<FavoriteBloc>().add(FavoriteUpdateEvent(
                        favorite: FavoriteModel(
                          id: widget.id,
                          idUser: 0,
                          description: _descriptionController.text,
                          title: _titleController.text,
                        ),
                      ));
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
    context.read<FavoriteBloc>().add(FavoriteListIdEvent(id: widget.id));
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
                onPressed: () => _deleteFavorite(context),
                icon: const Icon(
                  Icons.delete,
                )),
            const SizedBox(width: 5)
          ],
        ),
        body: BlocListener<FavoriteBloc, FavoriteState>(
          listener: (context, stateFavoriteListener) {
            if (stateFavoriteListener is FavoriteUpdateState) {
              Navigator.pop(context, true);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            }
            if (stateFavoriteListener is FavoriteDeleteState) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            }
          },
          child: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, stateFavoriteList) {
            if (stateFavoriteList is FavoriteLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (stateFavoriteList is FavoriteErrorState) {
              return const Center(child: Text('Error Data is not found'));
            } else if (stateFavoriteList is FavoriteListIdState) {
              final favoriteList = stateFavoriteList.favoriteList;
              return ListView.builder(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  final favorite = favoriteList[index];
                  return ListTile(
                    // tileColor: colorTheme.primary,
                    leading: Image.asset(
                      'lib/images/banner1.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(favorite.name!, maxLines: 1),
                    subtitle: Text(favorite.description!, maxLines: 1),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle the tap event, e.g., navigate to a details page
                      // print('Tapped on ${favorite.title}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                    id: favorite.idProduct!,
                                    redirect: 'favorite',
                                    lastId: widget.id,
                                  )));
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('Something went wrong Bloc or API'));
            }
          }),
        ));
  }
}
