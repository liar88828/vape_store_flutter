import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/screen/favorite/favorite_form_screen.dart';
import 'package:vape_store/screen/favorite/favorite_detail_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FavoriteBloc>().add(FavoriteLoadsEvent());
    final colorTheme = Theme.of(context).colorScheme;

    void goFavoriteFormScreen() async {
      final result = await Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return FavoriteFormScreen();
        },
      ));
      if (context.mounted) {
        if (result == true) {
          context.read<FavoriteBloc>().add(FavoriteLoadsEvent());
        }
      }
    }

    void goTrolleyScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const TrolleyScreen();
      }));
    }

    void goHomeScreen() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    }

    void goFavoriteDetailScreen(FavoriteModel favorite) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoriteDetailScreen(
            idFavorite: favorite.id ?? 0,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => goHomeScreen(),
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
                  ))),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BlocSelector<TrolleyBloc, TrolleyState, int>(
              selector: (stateTrolley) {
                return stateTrolley.count ?? 0;
              },
              builder: (context, stateTrolleyCount) {
                return IconButton(
                    color: colorTheme.primary,
                    style: IconButton.styleFrom(
                        backgroundColor: colorTheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    // color: Colors.red,
                    onPressed: () => goTrolleyScreen(),
                    icon: Badge(
                      label: Text(stateTrolleyCount.toString()),
                      child: const Icon(Icons.trolley),
                    ));
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              BlocSelector<FavoriteBloc, FavoriteState, int>(
                selector: (stateFavorite) {
                  return stateFavorite.count ?? 0;
                },
                builder: (context, stateFavoriteCount) {
                  return Text(
                    'Total : $stateFavoriteCount',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  );
                },
              ),
              IconButton(
                color: colorTheme.primary,
                style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => goFavoriteFormScreen(),
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
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, stateFavorites) {
              if (stateFavorites is FavoriteLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateFavorites is FavoriteErrorState) {
                return Center(child: Text('Error Data is not found : ${stateFavorites.message}'));
              } else if (stateFavorites is FavoriteLoadsState) {
                final favorites = stateFavorites.favorites;
                return Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    primary: false,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    children: favorites.map((favorite) {
                      return InkWell(
                        onTap: () => goFavoriteDetailScreen(favorite),
                        child: Card(
                          key: Key(favorite.id.toString()),
                          color: colorTheme.onPrimary,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: Image.asset('lib/images/banner1.png', height: 150, width: 150)),
                                const SizedBox(height: 10),
                                Text(
                                  favorite.title,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text("Item : ${favorites.length}")
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const Text('Something error Bloc or Api');
              }
            },
          )
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const ProductCard({super.key, required this.image, required this.title, required this.price});
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
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
