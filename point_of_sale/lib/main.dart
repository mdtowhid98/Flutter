import 'package:flutter/material.dart';
import 'package:point_of_sale/page/Category.dart';
import 'package:point_of_sale/page/Home.dart';


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
      home: Home(),
    );

  }
}
