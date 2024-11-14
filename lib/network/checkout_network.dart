import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/checkout_model.dart';

class CheckoutNetwork {
  final baseUrl = 'http://localhost:8000/api';

  Future<List<CheckoutModel>> fetchAll(int idUser) async {
    final response =
        await http.get(Uri.parse("$baseUrl/checkout/id-user/$idUser"));
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      final List<dynamic> data = dataJson['data'];
      return data.map((json) => CheckoutModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Checkout');
    }
  }
}