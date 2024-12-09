import 'package:flutter/material.dart';
import 'package:task_flutter/page/ActivityPage.dart';
import 'package:task_flutter/page/LoginScreen.dart';
import 'package:task_flutter/page/ProfileScreen.dart';
import 'package:task_flutter/page/RegistrationPage.dart';
import 'package:task_flutter/page/UpdateProfileScreen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',  // This is the starting route (LoginPage)
      routes: {
        '/': (context) => LoginScreen(),  // Route for login page
        '/register': (context) => RegistrationPage(),  // Route for register page
        '/activity': (context) => ActivityPage(),
        '/profile': (context) => ProfileScreen(),
        '/update-profile': (context) => UpdateProfileScreen(),// Route for activity page
      },
    );
  }


}
