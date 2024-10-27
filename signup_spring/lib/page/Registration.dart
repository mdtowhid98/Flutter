import 'dart:convert';
import 'dart:html' as html; // Import dart:html for web file handling
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'package:signup_spring/page/Login.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  String? selectedGender;
  DateTime? selectedDOB;
  html.File? selectedImage; // Use html.File to store the selected image
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String uName = name.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uCell = cell.text;
      String uAddress = address.text;
      String uGender = selectedGender ?? 'Other';
      String uDob = selectedDOB != null ? selectedDOB!.toIso8601String() : '';

      final response = await _sendDataToBackend(uName, uEmail, uPassword, uCell, uAddress, uGender, uDob, selectedImage);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Registration successful!');
      } else if (response.statusCode == 409) {
        print('User already exists!');
      } else {
        print('Registration failed with status: ${response.statusCode}');
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name,
      String email,
      String password,
      String cell,
      String address,
      String gender,
      String dob,
      html.File? image) async {
    const String url = 'http://localhost:8087/register'; // Change this to your server URL
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['cell'] = cell;
    request.fields['address'] = address;
    request.fields['gender'] = gender;
    request.fields['dob'] = dob;

    // If an image is selected, add it to the request
    if (image != null) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(image);
      await reader.onLoad.first; // Wait for the file to load
      final bytes = reader.result as List<int>;
      request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: image.name));
    }

    return await request.send().then((response) => http.Response.fromStream(response));
  }

  void _pickImage() {
    // Create an input element for file selection
    final input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Accept image files
    input.onChange.listen((e) {
      final files = input.files;
      if (files!.isEmpty) return;
      setState(() {
        selectedImage = files[0]; // Store the selected file
      });
    });
    input.click(); // Open the file selector
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(name, 'Full Name', Icons.person),
                SizedBox(height: 20),
                _buildTextField(email, 'Email', Icons.email),
                SizedBox(height: 20),
                _buildTextField(password, 'Password', Icons.lock, obscureText: true),
                SizedBox(height: 20),
                _buildTextField(confirmPassword, 'Confirm Password', Icons.lock, obscureText: true),
                SizedBox(height: 20),
                _buildTextField(cell, 'Cell Number', Icons.phone),
                SizedBox(height: 20),
                _buildTextField(address, 'Address', Icons.maps_home_work_rounded),
                SizedBox(height: 20),
                DateTimeFormField(
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildGenderSelection(),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 10),
                        Text(selectedImage == null ? 'Choose file' : 'File selected: ${selectedImage!.name}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Gender:'),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              Text('Male'),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              Text('Female'),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: 'Other',
                groupValue: selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              Text('Other'),
            ],
          ),
        ),
      ],
    );
  }
}
