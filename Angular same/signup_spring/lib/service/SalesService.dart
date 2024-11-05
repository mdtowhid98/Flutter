import 'dart:convert';

import 'package:signup_spring/model/Sales.dart';
import 'package:http/http.dart' as http;

class SalesService {
  final String baseUrl = "http://localhost:8087/api/sales/";

  Future<Sale> createSales(Sale sale) async {
    final response = await http.post(
      Uri.parse("${baseUrl}dhanmondi"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sale.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sale: ${response.body}');
    }
  }
}