// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/response_model.dart';
import 'package:vape_store/models/trolley_model.dart';

class TrolleyNetwork {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<int> fetchTrolleyCount(int idUser) async {
    print(idUser);
    final response = await http.get(Uri.parse("$baseUrl/trolley/id-user/count/$idUser"));
    final jsonData = json.decode(response.body);
    var code = response.statusCode;

    if (code == 200) {
      final data = jsonData['data'];
      return data;
    } else {
      throw Exception('Failed to load trolley count : ${jsonData['message']}');
    }
  }

  Future<List<TrolleyModel>> fetchTrolleyCurrent(int idUser) async {
    final response = await http.get(Uri.parse("$baseUrl/trolley/id-user/$idUser"));
    final jsonData = json.decode(response.body);
    final code = response.statusCode;
    if (code == 200) {
      final List<dynamic> trolleyData = jsonData['data'];
      // print(trolleyData);
      return trolleyData.map((trolley) => TrolleyModel.fromJson(trolley)).toList();
    } else {
      throw Exception('Failed to load trolley : ${jsonData['message']}');
    }
  }

  Future<List<TrolleyModel>> fetchTrolleyCheckout({required int idCheckout}) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/trolley/id-checkout/$idCheckout"));
      final jsonData = json.decode(response.body);
      final code = response.statusCode;

      if (code == 200) {
        final List<dynamic> trolleyData = jsonData['data'];
        return trolleyData.map((trolley) => TrolleyModel.fromJson(trolley)).toList();
      } else {
        throw Exception('Failed to load trolley : ${jsonData['message']}');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<ResponseModel> addTrolley(TrolleyCreate trolley) async {
    final response = await http.post(
      Uri.parse("$baseUrl/trolley"),
      body: jsonEncode(trolley.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    final jsonData = jsonDecode(response.body);
    var code = response.statusCode;
    if (code == 200) {
      return ResponseModel(
        message: jsonData['message'],
        success: true,
      );
    } else {
      // print(jsonData['message']);
      throw Exception('Failed to add trolley : ${jsonData['message']}');
    }
  }

  Future<ResponseModel> changeTrolley(TrolleyCreate trolley) async {
    final response = await http.put(
      Uri.parse("$baseUrl/trolley/${trolley.id}"),
      body: jsonEncode(trolley.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    final jsonData = jsonDecode(response.body);
    final code = response.statusCode;
    if (code == 200) {
      return ResponseModel(success: true, message: jsonData['message']);
    } else {
      print(jsonData['message']);
      throw Exception('Failed to add trolley : ${jsonData['message']}');
    }
  }

  Future<ResponseModel> removeTrolley(int idTrolley) async {
    final response = await http.delete(Uri.parse("$baseUrl/trolley/$idTrolley"));
    final code = response.statusCode;
    final jsonData = jsonDecode(response.body);
    print(response.statusCode);
    if (code == 200) {
      return ResponseModel(success: true, message: jsonData['message']);
    } else {
      throw Exception('Failed to remove trolley : ${jsonData['message']}');
    }
  }
}
