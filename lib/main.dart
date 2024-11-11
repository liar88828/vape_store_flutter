import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/user_network.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/screen/favorite/favorite_list_screen.dart';
import 'package:vape_store/screen/favorite/favorites_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/auth/login_screen.dart';
import 'package:vape_store/screen/order_screen.dart';
import 'package:vape_store/screen/product/product_list.dart';
import 'package:vape_store/screen/profile_screen.dart';
import 'package:vape_store/screen/auth/register_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/screen/setting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          // Theme.of(context).colorScheme.inversePrimary
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        ));
  }
}
