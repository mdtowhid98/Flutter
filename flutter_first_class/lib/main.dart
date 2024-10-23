import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("First Flutter Class",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
            IconButton(onPressed: () {}, icon: Icon(Icons.contact_mail)),
          ],
        ),
        body: Center(
          child: Text("Flutter "),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.thumb_up, color: Colors.red),
            backgroundColor: Colors.lightGreenAccent),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: Colors.green,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),label: "Home"),


              BottomNavigationBarItem(
                  icon: Icon(Icons.contact_mail), label: "Contact"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
      ),
    );
  }
}
