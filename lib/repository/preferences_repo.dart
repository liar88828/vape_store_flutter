// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vape_store/models/user_model.dart';

class PreferencesRepository {
  static const THEME_KEY = 'theme';
  static const TOKEN_KEY = 'token';
  static const USER_KEY = 'user';

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_KEY) ?? false;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY) ?? '';
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
  }

  Future<bool> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(TOKEN_KEY);
  }

  Future<void> setUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_KEY, jsonEncode(user.toJson()));
  }

  Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(USER_KEY);
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(USER_KEY);
  }
}
