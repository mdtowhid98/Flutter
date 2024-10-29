import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signup_spring/model/Supplier.dart';

class SupplierService {
  final String apiUrl = 'http://localhost:8087/api/supplier/';

  Future<List<Supplier>> fetchSuppliers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> supplierJson = json.decode(response.body);
      return supplierJson.map((json) => Supplier.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }
}

class CreateSupplierService {
  final String apiUrl = 'http://localhost:8087/api/supplier/save';

  Future<http.Response> createSupplier(String name, String email, int cell, String address) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'cell': cell,
        'address': address,
      }), // Adjusted to use lowercase keys
    );

    return response;
  }
}
