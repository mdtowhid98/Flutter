import 'package:signup_spring/model/Category.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
