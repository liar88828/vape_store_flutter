import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/response_model.dart';

class CheckoutNetwork {
  final baseUrl = 'http://localhost:8000/api';

  Future<List<CheckoutModel>> fetchAll(int idUser) async {
    print(idUser);
    final response = await http.get(Uri.parse("$baseUrl/checkout/id-user/$idUser"));
    if (response.statusCode == 201) {
      final dataJson = jsonDecode(response.body);
      final List<dynamic> data = dataJson['data'];
      return data.map((json) => CheckoutModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Checkout');
    }
  }

  Future<CheckoutModel> fetchId(int idCheckout) async {
    final response = await http.get(Uri.parse("$baseUrl/checkout/$idCheckout"));
    if (response.statusCode == 201) {
      final dataJson = jsonDecode(response.body);
      return CheckoutModel.fromJson(dataJson['data']);
    } else {
      throw Exception('Failed to load Checkout');
    }
  }

  Future<ResponseModel> createCheckout(CheckoutModel checkout, List<int> idTrolley) async {
    try {
      final data = {
        "id_user": checkout.idUser,
        "id_trolley": idTrolley,
        "total": checkout.total,
        "delivery_price": checkout.deliveryPrice,
        "payment_price": checkout.paymentPrice,
        "payment_method": checkout.paymentMethod,
        "delivery_method": checkout.deliveryMethod,
      };
      print(data);
      final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body);
        String message = dataJson['message'];
        print(message);
        return ResponseModel(
          success: true,
          message: message,
        );
      } else {
        // String message = dataJson['message'];
        // print(message);
        throw Exception('error bos');
      }
    } catch (e) {
      print(e.toString());
      return ResponseModel(message: 'Error Checkout', success: false);
    }
  }
}
