import 'package:flutter/material.dart';
import 'package:signup_spring/page/All_Product_view.dart';
import 'package:signup_spring/page/Login.dart';
import 'package:signup_spring/page/Registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );

  }
}
