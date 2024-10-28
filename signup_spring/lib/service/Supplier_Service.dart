import 'package:signup_spring/model/Category.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:signup_spring/model/Supplier.dart';

class SupplierService {

  final String apiUrl = 'http://localhost:8087/api/supplier/';

  Future<List<Supplier>> fetchSuppliers() async {
    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> supplierJson = json.decode(response.body);

      return supplierJson.map((json) => Supplier.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }
}