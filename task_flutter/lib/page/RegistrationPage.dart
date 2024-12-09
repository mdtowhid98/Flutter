import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb constant
import 'package:image_picker_web/image_picker_web.dart';
import 'package:task_flutter/page/ActivityPage.dart';
import 'package:task_flutter/page/LoginScreen.dart';


class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController address = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // Image data variables
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _imageData;

  final String apiUrl = "http://139.59.65.225:8052/user/register";

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_imageData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select an image.")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      String uFirstName = firstName.text;
      String uLastName = lastName.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uAddress = address.text;

      try {
        final response = await _sendDataToBackend(
          uFirstName, uLastName, uEmail, uPassword, uAddress,
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ActivityPage()));
          print('Registration successful!');
        } else if (response.statusCode == 409) {
          print('User already exists!');
        } else {
          print('Registration failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('An error occurred: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          _imageData = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() async {
          _imageFile = pickedImage;
          _imageData = await pickedImage.readAsBytes();
        });
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String firstName,
      String lastName,
      String email,
      String password,
      String address,
      ) async {
    const String url = 'http://139.59.65.225:8052/user/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'address': address,
        'image': _imageData != null ? base64Encode(_imageData!) : null,
      }),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
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
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(firstName, 'First Name', Icons.person),
                      SizedBox(height: 16),
                      _buildTextField(lastName, 'Last Name', Icons.person),
                      SizedBox(height: 16),
                      _buildTextField(email, 'Email', Icons.email),
                      SizedBox(height: 16),
                      _buildPasswordField(password, 'Password', _isPasswordVisible, (value) {
                        setState(() {
                          _isPasswordVisible = value;
                        });
                      }),
                      SizedBox(height: 16),
                      _buildTextField(address, 'Address', Icons.maps_home_work_rounded),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.add_photo_alternate),
                        label: Text('Choose Image'),
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40)),
                      ),
                      SizedBox(height: 16),
                      if (_imageData != null)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(_imageData!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Text(
                          'No image selected',
                          style: TextStyle(color: Colors.grey),
                        ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      )
                          : ElevatedButton(
                        onPressed: _register,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.lato().fontFamily,
                            color: Colors.black,
                          ),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
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
    );
  }

  // TextField builder method
  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        isDense: true,
      ),
      style: TextStyle(color: Colors.black, fontSize: 12),
    );
  }

  // Password Field builder method
  Widget _buildPasswordField(TextEditingController controller, String labelText, bool isVisible, ValueChanged<bool> onToggleVisibility) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black),
          onPressed: () {
            onToggleVisibility(!isVisible);
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        isDense: true,
      ),
      obscureText: !isVisible,
      style: TextStyle(color: Colors.black, fontSize: 12),
    );
  }
}
