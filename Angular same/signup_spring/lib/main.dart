import 'package:flutter/material.dart';

import 'package:signup_spring/page/CreateSales.dart';
import 'package:signup_spring/page/Create_Category.dart';


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
      home: CreateSalesPage(),
    );

  }
}
