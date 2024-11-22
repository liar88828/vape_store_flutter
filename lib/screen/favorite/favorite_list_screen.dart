import 'package:flutter/material.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/screen/favorite/favorite_form_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteListScreenx extends StatelessWidget {
  const FavoriteListScreenx({super.key});

  @override
  Widget build(BuildContext context) {
    void deleteFavorite(BuildContext context, int id) {
      context.read<FavoriteBloc>().add(FavoriteDeleteEvent(id: id));
    }

    context.read<FavoriteBloc>().add(FavoriteListUserEvent());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FavoriteFormScreen();
              }));
              if (result == true) {
                if (context.mounted) {
                  context.read<FavoriteBloc>().add(FavoriteListUserEvent());
                }
              }
            },
          )
        ],
        title: const Text('Favorite List'),
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, stateFavoriteListener) {
          if (stateFavoriteListener is FavoriteDeleteState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Favorite Delete')));
            context.read<FavoriteBloc>().add(FavoriteListUserEvent());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fail to delete Favorite')));
          }
        },
        builder: (context, stateFavorite) {
          if (stateFavorite is FavoriteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (stateFavorite is FavoriteErrorState) {
            return const Center(child: Text('Error Data is not found'));
          } else if (stateFavorite is FavoriteListUserState) {
            final favorites = stateFavorite.favoriteList;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
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
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return FavoriteFormScreen(favorite: favorite);
                              }),
                            );
                            if (result == true) {
                              if (context.mounted) {
                                context.read<FavoriteBloc>().add(FavoriteListUserEvent());
                              }
                            }
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteFavorite(context, favorite.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Data is Empty'));
          }
        },
      ),
    );
  }
}
