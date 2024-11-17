import 'package:flutter/material.dart';
import 'package:vape_store/screen/favorite/favorites_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/profile_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/screen/setting_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('is start screen'),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
              Tab(icon: Icon(Icons.settings), text: 'Setting'),
            ]),
          ),
          body: const TabBarView(children: [
            HomeScreen(),
            FavoritesScreen(),
            SearchScreen(),
            ProfileScreen(),
            SettingScreen(),
          ]),
        ));
  }
}
