
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:point_of_sale/model/BranchModel.dart';

class BranchService {

  final String apiUrl = 'http://localhost:8087/api/branch/';

  Future<List<Branch>> fetchBranches() async {
    final response = await http.get(Uri.parse(apiUrl));



    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> branchJson = json.decode(response.body);

      return branchJson.map((json) => Branch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }
}

class CreateBranchService {
  final String apiUrl = 'http://localhost:8087/api/branch/save';

  Future<http.Response> createBranch(String branchName, String location) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'branchName': branchName, // Updated to use 'branchName'
        'location': location,
      }),
    );

    return response;
  }
}