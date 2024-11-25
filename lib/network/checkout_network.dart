import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/response_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';

class CheckoutNetwork {
  final baseUrl = 'http://localhost:8000/api';

  Future<List<CheckoutModel>> fetchAll(int idUser) async {
    // print(idUser);
    final response = await http.get(Uri.parse("$baseUrl/checkout/id-user/$idUser"));
    if (response.statusCode == 201) {
      final dataJson = jsonDecode(response.body);
      final List<dynamic> data = dataJson['data'];
      return data.map((json) => CheckoutModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Checkout');
    }
  }

  Future<CheckoutModel> fetchId({required int idCheckout}) async {
    final response = await http.get(Uri.parse("$baseUrl/checkout/$idCheckout"));
    if (response.statusCode == 201) {
      final dataJson = jsonDecode(response.body);
      return CheckoutModel.fromJson(dataJson['data']);
    } else {
      throw Exception('Failed to load Checkout');
    }
  }

  Future<ResponseModel> createSingleCheckout({
    required CheckoutModel checkout,
    required UserModel user,
    required TrolleyModel product,
  }) async {
    final data = {
      "id_product": product.idProduct,
      "type": product.type,
      "qty": product.trolleyQty,
      "id_user": user.id,
      "total": checkout.total,
      "delivery_price": checkout.deliveryPrice,
      "payment_price": checkout.paymentPrice,
      "payment_method": checkout.paymentMethod,
      "delivery_method": checkout.deliveryMethod,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/checkout/one'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    final dataJson = jsonDecode(response.body);
    String message = dataJson['message'];
    if (response.statusCode == 200) {
      var dataJson2 = dataJson['data'];
      print(dataJson2);
      final data = CheckoutModel.fromJson(dataJson2);

      print(data);
      return ResponseModel(
        success: true,
        message: message,
        data: data,
      );
    } else {
      throw Exception(message);
    }
  }

  Future<ResponseModel<CheckoutModel>> createManyCheckout({
    required CheckoutModel checkout,
    required List<int> idTrolley,
    required UserModel user,
  }) async {
    final data = {
      "id_user": user.id,
      "id_trolley": idTrolley,
      "total": checkout.total,
      "delivery_price": checkout.deliveryPrice,
      "payment_price": checkout.paymentPrice,
      "payment_method": checkout.paymentMethod,
      "delivery_method": checkout.deliveryMethod,
    };
    // print("is many");
    // print(data);
    // print(data);
    final response = await http.post(
      Uri.parse('$baseUrl/checkout/many'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    final dataJson = jsonDecode(response.body);
    String message = dataJson['message'];
    if (response.statusCode == 200) {
      var dataJson2 = dataJson['data'];
      print(dataJson2);
      final data = CheckoutModel.fromJson(dataJson2);

      print(data);
      return ResponseModel(
        success: true,
        message: message,
        data: data,
      );
    } else {
      throw Exception(message);
    }
  }

  Future<List<ProductModel>> fetchTrolleyCheckout(int idCheckout) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/checkout/id-checkout/$idCheckout"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> trolleyData = jsonData['data'];
        // print(trolleyData);
        return trolleyData.map((trolley) => ProductModel.fromJson(trolley)).toList();
      } else {
        throw Exception('Failed to load trolley');
      }
    } catch (e) {
      // print(e.toString());
      return [];
    }
  }
}
