// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/models/response_model.dart';

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
    // print('the is user is : $idUser');
    final response = await http.get(Uri.parse("$baseUrl/favorite/id-user/$idUser"));
    final jsonData = jsonDecode(response.body);
    final code = response.statusCode;

    // print('test data');
    if (code == 201) {
      // print(favoriteData);
      final List<dynamic> favoriteData = jsonData['data'];
      return favoriteData.map((json) => FavoriteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<int> fetchFavoritesByUserIdCount(int idUser) async {
    final response = await http.get(Uri.parse("$baseUrl/favorite/id-user/count/$idUser"));
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final int favoriteData = jsonData['data'];
      // print(favoriteData);
      return favoriteData;
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<List<FavoriteListModel>> fetchFavoritesByListId(int idFavorite) async {
    final response = await http.get(Uri.parse("$baseUrl/favorite/id-list/$idFavorite"));
    final jsonData = jsonDecode(response.body);
    final code = response.statusCode;
    if (code == 201) {
      final List<dynamic> favoriteData = jsonData['data'];
      return favoriteData.map((json) => FavoriteListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<FavoriteModel> fetchFavoriteById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/favorite/$id"));
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return FavoriteModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load favorite');
    }
  }

  Future<String> createFavoriteCase(FavoriteModel favorite) async {
    final response = await http.post(
      Uri.parse("$baseUrl/favorite"),
      body: jsonEncode(favorite.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    final jsonData = json.decode(response.body);
    var code = response.statusCode;
    if (code == 200) {
      return jsonData['message'];
    } else {
      throw Exception('Failed to create favorite : ${jsonData['message']}');
    }
  }

  Future<ResponseModel> addFavoriteList(FavoriteListCreate favorite) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/favorite/list/${favorite.idFavorite}"),
        body: jsonEncode(favorite.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      final jsonData = json.decode(response.body);
      print(jsonData['message']);
      if (response.statusCode == 200) {
        return ResponseModel(success: true, message: jsonData['message']);
      } else {
        throw Exception('Failed to add favorite list');
      }
    } catch (e) {
      print(e);
      return ResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseModel> updateFavoriteCase(
    FavoriteModel favorite,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/favorite/${favorite.id}'),
      body: jsonEncode(favorite.toJson()),
      headers: {'Content-Type': "application/json"},
    );
    final jsonData = json.decode(response.body);
    final code = response.statusCode;
    if (code == 200) {
      return ResponseModel(success: true, message: jsonData['message']);
    } else {
      throw Exception('Failed to update favorite : ${jsonData['message']}');
    }
  }

  Future<ResponseModel> deleteFavorite(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/favorite/$id"));
    final jsonData = json.decode(response.body);
    final code = response.statusCode;

    if (code == 200) {
      return ResponseModel(success: true, message: jsonData['message']);
    } else {
      throw Exception('Failed to delete favorite : ${jsonData['message']}');
    }
  }

  Future<ResponseModel> deleteToFavoriteList(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/favorite/list/$id"));
    final jsonData = json.decode(response.body);
    final code = response.statusCode;

    if (code == 200) {
      return ResponseModel(success: true, message: jsonData['message']);
    } else {
      throw Exception('Failed to delete favorite : ${jsonData['message']}');
    }
  }
}
