import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://206.189.138.45:8052';
  static String? userToken;

  // 🔐 Login User
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      userToken = data['data']['token'];
      return data;
    } else {
      throw Exception('Login failed');
    }
  }

  // 🧑‍💼 Get Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final url = Uri.parse('$baseUrl/user/my-profile');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  // ✍️ Update Profile
  static Future<Map<String, dynamic>> updateProfile(
      String firstName, String lastName, String address) async {
    final url = Uri.parse('$baseUrl/user/update-profile');
    var request = http.MultipartRequest('PATCH', url);
    request.headers['Authorization'] = 'Bearer $userToken';
    request.fields['firstName'] = firstName;
    request.fields['lastName'] = lastName;
    request.fields['address'] = address;

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
