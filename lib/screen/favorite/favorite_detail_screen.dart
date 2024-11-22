import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/screen/favorite/favorites_screen.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';

class FavoriteDetailScreen extends StatefulWidget {
  const FavoriteDetailScreen({
    super.key,
    required this.idFavorite,
  });
  final int idFavorite;

  @override
  State<FavoriteDetailScreen> createState() => _FavoriteDetailScreenState();
}

class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
                  context.read<FavoriteBloc>().add(FavoriteDeleteEvent(id: widget.idFavorite));
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

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    context.read<FavoriteBloc>().add(FavoriteListIdEvent(idFavorite: widget.idFavorite));
    // for form
    Future<void> editFavorite() async {
      context.read<FavoriteBloc>().add(FavoriteListIdUserEvent(idFavorite: widget.idFavorite));

      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, stateFavoriteForm) {
              if (stateFavoriteForm is FavoriteLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateFavoriteForm is FavoriteErrorState) {
                return Text(stateFavoriteForm.message);
              } else if (stateFavoriteForm is FavoriteListIdUserState) {
                _titleController.text = stateFavoriteForm.favorite.title;
                _descriptionController.text = stateFavoriteForm.favorite.description;
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
                                id: widget.idFavorite,
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
              } else {
                return const Text("Something error");
              }
            });
          });
    }

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
                onPressed: editFavorite,
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
        body: BlocConsumer<FavoriteBloc, FavoriteState>(
          listener: (context, stateFavoriteListener) {
            if (stateFavoriteListener is FavoriteDeleteSuccessState) {
              context.read<FavoriteBloc>().add(FavoriteListIdEvent(idFavorite: widget.idFavorite));
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateFavoriteListener.message)));
            }
            if (stateFavoriteListener is FavoriteUpdateState) {
              Navigator.pop(context, true);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            }
            if (stateFavoriteListener is FavoriteDeleteState) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            }
          },
          // buildWhen: (previous, current) {
          //   // return previous. != current.favoriteList;
          // },
          builder: (context, stateFavoriteList) {
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
                    trailing: SizedBox(
                      width: 120, // Adjust the width based on your button sizes
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<FavoriteBloc>().add(FavoriteListDeleteEvent(idFavoriteList: favorite.favoriteListsId));
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    id: favorite.idProduct,
                                    redirect: 'favorite',
                                    lastId: widget.idFavorite,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Something went wrong Bloc or API'));
            }
          },
        ));
  }
}
