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

class Activity1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity1"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Activity2()));
        },
            child: Text("go Activity2")
        ),
      ),
    );
  }

}

class Activity2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity2"),
      ),
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

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Activity1()));
              },
              child: Text("go Activity1"),

          ),
          ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Activity2()));
              },
              child: Text("go Activity2")
          )
        ],
      ),
    );
  }

}

