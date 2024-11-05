import 'package:flutter/material.dart';
import 'package:vape_store/screen/detail_screen.dart';
import 'package:vape_store/screen/favorites_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/login_screen.dart';
import 'package:vape_store/screen/order_screen.dart';
import 'package:vape_store/screen/profile_screen.dart';
import 'package:vape_store/screen/register_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/screen/setting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: LoginScreen(),
    );
  }
}
