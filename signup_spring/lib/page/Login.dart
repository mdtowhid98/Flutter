import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:signup_spring/page/Home.dart';
import 'package:signup_spring/page/Registration.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final storage=new FlutterSecureStorage();



  Future<void>loginUser(BuildContext context)async{
    final url=Uri.parse('http://localhost:8087/login');

    final response=await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email':email.text,'password':password.text}),
    );

    if(response.statusCode==200){
      final responseData=jsonDecode(response.body);
      final token=responseData['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String sub=payload['sub'];
      String role=payload['role'];

      await storage.write(key: 'token', value: token);
      await storage.write(key: 'sub', value: sub);
      await storage.write(key: 'role', value: role);

      print('Login successful. Sub: $sub, Role: $role');


      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Home())
      );

    }else{
      print('Login failed with status: ${response.statusCode}');
    }


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: password,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.lock), // Changed from Icons.password to Icons.lock
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginUser(context);
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
              ),
            ),

            SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text(
                'Registration',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
