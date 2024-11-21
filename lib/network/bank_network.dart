import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/bank_model.dart';

class BankNetwork {
  final String baseUrl = 'http://localhost:8000/api';

  Future<List<BankModel>> fetchBanks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bank'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        return data.map((json) => BankModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load banks');
    } catch (e) {
      print(e.toString());
      throw Exception('fail fetch data banks');
    }
  }
}
