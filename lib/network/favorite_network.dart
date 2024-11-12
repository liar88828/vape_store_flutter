// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';

class FavoriteNetwork {
  final String baseUrl = 'http://127.0.0.1:8000/api';
  Future<List<FavoriteModel>> fetchFavorites() async {
    final response = await http.get(Uri.parse("$baseUrl/favorite"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> favoriteData = jsonData['data'];
      print(favoriteData);
      return favoriteData.map((json) => FavoriteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<List<FavoriteModel>> fetchFavoritesByUserId(int idUser) async {
    final response =
        await http.get(Uri.parse("$baseUrl/favorite/id-user/$idUser"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> favoriteData = jsonData['data'];
      print(favoriteData);
      return favoriteData.map((json) => FavoriteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<int> fetchFavoritesByUserIdCount(int idUser) async {
    // print('-------');
    // print('user : $id_user');
    // print('-------');

    final response =
        await http.get(Uri.parse("$baseUrl/favorite/id-user/count/$idUser"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final int favoriteData = jsonData['data'];
      // print(favoriteData);
      return favoriteData;
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<List<FavoriteListModel>> fetchFavoritesByListId(int idFavorite) async {
    final response =
        await http.get(Uri.parse("$baseUrl/favorite/id-list/$idFavorite"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> favoriteData = jsonData['data'];
      print(favoriteData);
      return favoriteData
          .map((json) => FavoriteListModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<FavoriteModel> fetchFavoriteById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/favorite/$id"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return FavoriteModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load favorite');
    }
  }

  Future<String> createFavorite(FavoriteModel favorite) async {
    // print(favorite.toJson());
    final response = await http.post(
      Uri.parse("$baseUrl/favorite"),
      body: jsonEncode(favorite.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(response.body);
      // final favorite = FavoriteModel.fromJson(jsonData['data']);
      return jsonData['message'];
    } else {
      throw Exception('Failed to create favorite');
    }
  }

  Future<bool> updateFavorite(FavoriteModel favorite) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/favorite/${favorite.id}'),
        body: jsonEncode(favorite.toJson()),
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['message']);
        return true;
      } else {
        throw Exception('Failed to update favorite');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteFavorite(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/favorite/$id"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['message']);
        return true;
      } else {
        throw Exception('Failed to delete favorite');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
