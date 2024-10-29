import 'package:flutter/material.dart';
import 'package:signup_spring/page/All_Product_view.dart';
import 'package:signup_spring/page/CreateProduct.dart';
import 'package:signup_spring/page/Create_Branch.dart';
import 'package:signup_spring/page/Create_Category.dart';
import 'package:signup_spring/page/Create_Supplier.dart';
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
      home: CreateProduct(),
    );

  }
}
