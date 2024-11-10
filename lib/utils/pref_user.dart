import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// Function to load user data from SharedPreferences and return a UserModel
Future<UserModel?> loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');
  if (userJson != null) {
    Map<String, dynamic> userMap = json.decode(userJson);
    return UserModel.fromJson(userMap);
  }
  return null;
}
