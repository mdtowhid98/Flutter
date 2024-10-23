import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatelessWidget {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.00),

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
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.green),
                ),

                prefixIcon: Icon(Icons.password),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String em=email.text;
                String pass=password.text;
                print('Email:$em,Password:$pass');

              },
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.lato().fontFamily
                ),

              ),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
              ),

            )
          ],
        ),
      ),
    );
  }
}