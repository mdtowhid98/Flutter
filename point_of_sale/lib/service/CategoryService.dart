import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:point_of_sale/model/CategoryModel.dart';


class CategoryService {
  final String apiUrl = 'http://localhost:8087/api/category/';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> categoryJson = json.decode(response.body);
      return categoryJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

class CreateCategoryService {
  final String apiUrl = 'http://localhost:8087/api/category/save';

  Future<http.Response> createCategory(String categoryName) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'categoryname': categoryName}), // Adjust according to your API's expected payload
    );

    return response;
  }
}