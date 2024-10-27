import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/page/Login.dart';

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
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  DateTime? selectedDOB;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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

      final response = await _sendDataToBackend(uName, uEmail, uPassword, uCell, uAddress, uGender, uDob);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
      ) async {
    const String url = 'http://localhost:8087/register'; // Android emulator
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'cell': cell,
        'address': address,
        'gender': gender,
        'dob': dob,
      }),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Register',
                          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(name, 'Full Name', Icons.person),
                        SizedBox(height: 16),
                        _buildTextField(email, 'Email', Icons.email),
                        SizedBox(height: 16),
                        _buildPasswordField(password, 'Password', _isPasswordVisible, (value) {
                          setState(() {
                            _isPasswordVisible = value;
                          });
                        }),
                        SizedBox(height: 16),
                        _buildPasswordField(confirmPassword, 'Confirm Password', _isConfirmPasswordVisible, (value) {
                          setState(() {
                            _isConfirmPasswordVisible = value;
                          });
                        }),
                        SizedBox(height: 16),
                        _buildTextField(cell, 'Cell Number', Icons.phone),
                        SizedBox(height: 16),
                        _buildTextField(address, 'Address', Icons.maps_home_work_rounded),
                        SizedBox(height: 16),
                        DateTimeFormField(
                          decoration: const InputDecoration(labelText: 'Date of Birth'),
                          mode: DateTimeFieldPickerMode.date,
                          pickerPlatform: dob,
                          onChanged: (DateTime? value) {
                            setState(() {
                              selectedDOB = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        _buildGenderSelection(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _register,
                          child: Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: GoogleFonts.lato().fontFamily),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.lightGreenAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText, bool isVisible, ValueChanged<bool> onToggleVisibility) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            onToggleVisibility(!isVisible);
          },
        ),
      ),
      obscureText: !isVisible,
    );
  }

  Widget _buildGenderSelection() {
    return Row(
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
