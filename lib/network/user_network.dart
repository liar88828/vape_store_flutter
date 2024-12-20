// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vape_store/bloc/auth/auth_bloc.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNetwork {
  final String baseUrl = 'http://localhost:8000/api';

  // Fetch all users
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/user'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Fetch a single user by ID
  Future<UserModel> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$id'));

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Register
  Future<AuthLoadedState> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final token = jsonData['token'];
      final dataUser = jsonData['data'];
      return AuthLoadedState(token: token, user: UserModel.fromJson(dataUser));
    } else {
      throw Exception('Fail Register');
    }
  }

  // Login
  Future<AuthLoadedState> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      final token = data['token'];
      final dataUser = data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('token', token);
      prefs.setString('user', jsonEncode(dataUser));
      return AuthLoadedState(token: token, user: UserModel.fromJson(dataUser));
    } else {
      throw Exception('Fail Login');
    }
  }

  // Logout
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('success logout');
      // await prefs.remove('token');
      return true;
    } else {
      return false;
    }
  }
}
