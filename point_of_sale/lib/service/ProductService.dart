import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/service/AuthService.dart';

class ProductService {
  final Dio _dio = Dio();
  final AuthService authService = AuthService();

  // Replace localhost with your machine's IP if needed
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

  Future<void> createProduct(Product product, XFile imageFile) async {
    // Correctly await the token retrieval
    final String? token = await authService.getToken();

    final String url = 'https://your-api-endpoint.com/products'; // Update with your API endpoint
    final formData = FormData.fromMap({
      'name': product.name,
      'unitprice': product.unitprice,
      'stock': product.stock,
      'manufactureDate': product.manufactureDate,
      'expiryDate': product.expiryDate,
      'photo': await MultipartFile.fromFile(imageFile.path), // Adjust this if needed
      // Add any other required fields here
    });

    try {
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Use the retrieved token
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully created
        print('Product created: ${response.data}');
      } else {
        print('Error creating product: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error creating product: $e');
    }
  }


}
