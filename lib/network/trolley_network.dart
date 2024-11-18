// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/trolley_model.dart';

class TrolleyNetwork {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<int> fetchTrolleyCount(int idUser) async {
    print(idUser);
    final response = await http.get(Uri.parse("$baseUrl/trolley/id-user/count/$idUser"));

    if (response.statusCode == 200) {
      final dataJson = json.decode(response.body);
      final data = dataJson['data'];
      // print(data);
      return data;
    } else {
      throw Exception('Failed to load trolley count');
    }
  }

  Future<List<TrolleyModel>> fetchTrolleyCurrent(int idUser) async {
    print('fetch by user id :$idUser');
    final response = await http.get(Uri.parse("$baseUrl/trolley/id-user/$idUser"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> trolleyData = jsonData['data'];
      print(trolleyData);
      return trolleyData.map((trolley) => TrolleyModel.fromJson(trolley)).toList();
    } else {
      throw Exception('Failed to load trolley');
    }
  }

  Future<List<TrolleyModel>> fetchTrolleyCheckout(int idCheckout) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/trolley/id-checkout/$idCheckout"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> trolleyData = jsonData['data'];
        // print(trolleyData);
        return trolleyData.map((trolley) => TrolleyModel.fromJson(trolley)).toList();
      } else {
        throw Exception('Failed to load trolley');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> addTrolley(TrolleyCreate trolley) async {
    print(trolley.toJson());
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/trolley"),
        body: jsonEncode(trolley.toJson()),
        // body: jsonEncode({
        //   'id_user': trolley.idUser,
        //   'id_product': trolley.idProduct,
        //   'qty': trolley.qty,
        //   'type': trolley.type,
        // }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData['message']);
        return true;
      } else {
        final jsonData = jsonDecode(response.body);
        print(jsonData['message']);
        throw Exception('Failed to add trolley');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeTrolley(TrolleyCreate trolley) async {
    print(trolley.toJson());
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/trolley/${trolley.id}"),
        body: jsonEncode(trolley.toJson()),
        // body: jsonEncode({
        //   'id_user': trolley.idUser,
        //   'id_product': trolley.idProduct,
        //   'qty': trolley.qty,
        //   'type': trolley.type,
        // }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData['message']);
        return true;
      } else {
        final jsonData = jsonDecode(response.body);
        print(jsonData['message']);
        throw Exception('Failed to add trolley');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeTrolley(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/trolley/$id"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData['data']);
      return true;
    } else {
      final jsonData = jsonDecode(response.body);
      print(jsonData['data']);
      return false;
    }
  }
}
