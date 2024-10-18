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
  HomeActivity({super.key});

  void MySnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My App"),
          backgroundColor: Colors.lightGreenAccent, // Set the background color here
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.home),text: "Home",),
              Tab(icon: Icon(Icons.search),text: "Search",),
              Tab(icon: Icon(Icons.settings),text: "Settings",),
              Tab(icon: Icon(Icons.email),text: "Email",),
              Tab(icon: Icon(Icons.contact_mail),text: "Contact",),
              Tab(icon: Icon(Icons.person),text: "Person",),
              Tab(icon: Icon(Icons.access_alarm),text: "Alarm",),
              Tab(icon: Icon(Icons.account_balance),text: "Balance",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
          HomeFragement(),
            SearchFragement(),
            SettingsFragement(),
            EmailFragement(),
            ContactFragement(),
            ProfileFragement(),
            AlarmFragement(),
            BalanceFragement()
          ],
        ),
      ),
    );
  }
}

