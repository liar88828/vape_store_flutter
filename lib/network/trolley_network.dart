import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/trolley_model.dart';

class TrolleyNetwork {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<int> fetchTrolleyCount(int id_user) async {
    final response =
        await http.get(Uri.parse("$baseUrl/trolley/id-user/count/$id_user"));

    if (response.statusCode == 200) {
      final dataJson = json.decode(response.body);
      final data = dataJson['data'];
      // print(data);
      return data;
    } else {
      throw Exception('Failed to load trolley count');
    }
  }

  Future<List<TrolleyModel>> fetchTrolley(int id_user) async {
    final response = await http.get(Uri.parse("$baseUrl/trolley/$id_user"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> trolleyData = jsonData['data'];
      return trolleyData
          .map((trolley) => TrolleyModel.fromJson(trolley))
          .toList();
    } else {
      throw Exception('Failed to load trolley');
    }
  }

  Future<bool> addTrolley(TrolleyModel trolley) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/trolley"),
        body: jsonEncode(trolley.toString()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['message']);
        return true;
      } else {
        throw Exception('Failed to add trolley');
      }
    } catch (e) {
      return false;
    }
  }
}
