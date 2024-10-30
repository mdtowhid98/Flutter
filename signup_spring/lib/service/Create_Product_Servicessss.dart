// import 'dart:convert';
// import 'dart:io';
//
// import 'package:signup_spring/model/Product.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart' show kIsWeb;
//
// class CreateProductServicesss {
//   Future<Product> createProduct(Product product, File? image) async {
//     var request = http.MultipartRequest(
//       "POST",
//       Uri.parse("http://localhost:8087/api/product/save"),
//     );
//
//     request.fields['product'] = json.encode(product.toJson());
//
//     if (image != null) {
//       var file = await http.MultipartFile.fromPath('image', image.path);
//       request.files.add(file);
//     }
//
//     var response = await request.send();
//
//     if (response.statusCode == 200) {
//       final respStr = await response.stream.bytesToString();
//       return Product.fromJson(json.decode(respStr));
//     } else {
//       throw Exception('Failed to save product: ${response.reasonPhrase}');
//     }
//   }
// }