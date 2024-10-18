import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  var MyItems = [
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Towhid"},
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Shabab"},
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Nazmul"},
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Raju"},
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Neyamul"},
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Kutub"},
    {
      "img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg",
      "title": "Sanaullh"
    },
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Rezvi"},
    {"img": "https://i.postimg.cc/yNMJjzSK/download-1.jpg", "title": "Nirjas"},
  ];

  void MySnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  MyAlertDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
              child: AlertDialog(
            title: Text("Alert!"),
            content: Text("Do you want to delete?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    MySnackBar("Delete Success", context);
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")),
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
        titleSpacing: 10,
        toolbarHeight: 80,
        toolbarOpacity: 1,
        elevation: 4,
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(
              onPressed: () {
                MySnackBar("I am Commments", context);
              },
              icon: const Icon(Icons.comment)),
          IconButton(
              onPressed: () {
                MySnackBar("I am Search", context);
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () {
            MySnackBar("I am Floating Action button", context);
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.message), label: "Contact"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: "Profile"),
        ],
        onTap: (int index) {
          if (index == 0) {
            MySnackBar("I am Home buttom menu", context);
          }
          if (index == 1) {
            MySnackBar("I am Contact buttom menu", context);
          }
          if (index == 2) {
            MySnackBar("I am Profile buttom menu", context);
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                padding: EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.lightGreenAccent),
                  accountName: const Text(
                    "Md Towhidul Alam",
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: const Text(
                    "alammdtowhidul9@gmail.com",
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture:
                      Image.network("https://i.postimg.cc/258wCH8j/man.png"),
                  onDetailsPressed: () {
                    MySnackBar("This My Profile", context);
                  },
                )),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text(
                "Contact",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text(
                "Email",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text(
                "Phone",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 1, childAspectRatio: 1.2),
        itemCount: MyItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              MySnackBar(MyItems[index]["title"]!,
                  context); // Corrected the order of arguments
            },
            child: Container(
              margin: EdgeInsets.all(2),
              width: double.infinity,
              height: 250,
              child: Image.network(MyItems[index]["img"]!, fit: BoxFit.fill),
            ),
          );
        },
      ),
    );
  }
}
