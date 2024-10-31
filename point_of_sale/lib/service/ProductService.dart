
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:point_of_sale/model/ProductModel.dart';

class ProductService {
  final String apiUrl = 'http://localhost:8087/api/product/';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> productJson = json.decode(response.body);
      return productJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class CreateProductService {
  Future<Product> createProduct(Product product, File? image) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://localhost:8087/api/product/save"),
    );

    request.fields['product'] = json.encode(product.toJson());

    if (image != null) {
      var file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
    }

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      return Product.fromJson(json.decode(respStr));
    } else {
      throw Exception('Failed to save product: ${response.reasonPhrase}');
    }
  }
}