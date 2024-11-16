import 'package:flutter/material.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/screen/favorite/favorite_form_screen.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  final FavoriteNetwork _favoriteNetwork = FavoriteNetwork();
  late Future<List<FavoriteModel>> _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = _favoriteNetwork.fetchFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favorite = _favoriteNetwork.fetchFavorites();
    });
  }

  void _deleteFavorite(BuildContext context, int id) async {
    bool response = await _favoriteNetwork.deleteFavorite(id);
    if (context.mounted) {
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Favorite Delete')));
        _refreshFavorites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fail to delete Favorite')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FavoriteFormScreen();
              }));
              if (result == true) _refreshFavorites();
            },
          )
        ],
        title: const Text('Favorite List'),
      ),
      body: FutureBuilder<List<FavoriteModel>>(
        future: _favorite,
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
                  // leading: Image.network(favorite.image!),
                  leading: Image.asset('lib/images/banner1.png'),
                  title: Text(favorite.title),
                  subtitle: Text(favorite.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return FavoriteFormScreen(favorite: favorite);
                            }));
                            if (result == true) _refreshFavorites();
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteFavorite(context, favorite.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
