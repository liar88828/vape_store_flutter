import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/delivery_model.dart';

class DeliveryNetwork {
  final String baseUrl = 'http://localhost:8000/api';

  Future<List<DeliveryModel>> fetchDelivery() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bank'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        // print('-------delivery');
        // print(data);
        // print('-------delivery');
        return data.map((json) => DeliveryModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load Delivery');
    } catch (e) {
      print(e.toString());
      throw Exception('fail fetch data delivery');
    }
  }
}
