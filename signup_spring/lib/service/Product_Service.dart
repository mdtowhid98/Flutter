import 'dart:io';

import 'package:signup_spring/model/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

// class CreateProductService {
//   final String apiUrl = 'http://localhost:8087/api/product/save';
//
//   Future<http.Response> createProduct(
//       String name,
//       String photo,
//       int stock,
//       int quantity,
//       int unitPrice,
//       String manufactureDate,
//       String expiryDate,
//       String categoryName,
//       String supplierName,
//       String branchName,
//       ) async {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'name': name,
//         'photo': photo,
//         'stock': stock,
//         'quantity': quantity,
//         'unitPrice': unitPrice,
//         'manufactureDate': manufactureDate,
//         'expiryDate': expiryDate,
//         'categoryName': categoryName,
//         'supplierName': supplierName,
//         'branchName': branchName,
//       }),
//     );
//
//     return response;
//   }
// }

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

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return Product.fromJson(json.decode(respStr));
    } else {
      throw Exception('Failed to save product: ${response.reasonPhrase}');
    }
  }
}

