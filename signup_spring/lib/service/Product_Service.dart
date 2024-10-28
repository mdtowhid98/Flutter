

import 'package:signup_spring/model/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService{

  final String apiUrl = 'http://localhost:8087/api/product/';

  Future<List<Product>> fetchProducts() async {

    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> productJson = json.decode(response.body);

      return productJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

}