import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/fragement/Alarm.dart';
import 'package:flutter_tutorial/fragement/Balance.dart';
import 'package:flutter_tutorial/fragement/Contact.dart';
import 'package:flutter_tutorial/fragement/Email.dart';
import 'package:flutter_tutorial/fragement/Home.dart';
import 'package:flutter_tutorial/fragement/Profile.dart';
import 'package:flutter_tutorial/fragement/Search.dart';
import 'package:flutter_tutorial/fragement/Settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomeActivity(),
    );
  }
}


class HomeActivity extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(

      child: Card(
        elevation: 80,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        shadowColor: Colors.green,
        color: Colors.lightGreenAccent,
        child: SizedBox(
          height: 200,
          width: 200,
          child: Center(child: Text("This is card"),),
        ),
      ),
      ),
    );
  }


}

