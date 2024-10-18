import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green, // Light theme
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.amber, // Dark theme
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
    {
      "img": "data:image/jpeg;base64,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",
      "title": "Towhid"
    },
    {
      "img": "data:image/jpeg;base64,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",
      "title": "Shabab"
    },
    {
      "img": "data:image/jpeg;base64,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",
      "title": "Nazmul"
    },
    {
      "img": "data:image/jpeg;base64,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",
      "title": "Raju"
    },
    {
      "img": "data:image/jpeg;base64,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",
      "title": "Neyamul"
    },
  ];

  MySnackBar(context,msg) {
   return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  MyAlertDiolog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
              child: AlertDialog(
                title: Text("Alert !"),
                content: Text("Do you want to delete"),
                actions: [
                  TextButton(onPressed: () {
                    MySnackBar("Delete Success", context);
                    Navigator.of(context).pop();
                  }, child: Text("Yes")),
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text("No")),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    // Define common button styles
    ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.all(10),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );

    ButtonStyle textButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.all(10),
      backgroundColor: Colors.green, // Lighter background for TextButton
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );

    ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
      padding: EdgeInsets.all(10),
      side: BorderSide(color: Colors.amber, width: 2),
      backgroundColor: Colors.blueAccent,
      // Lighter background for TextButton
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory App"),
        titleSpacing: 10,
        toolbarHeight: 60,
        toolbarOpacity: 1,
        elevation: 4,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                MySnackBar("I am Comments", context);
              },
              icon: const Icon(Icons.comment)),
          IconButton(
              onPressed: () {
                MySnackBar("I am Search", context);
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                MySnackBar("I am Settings", context);
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                MySnackBar("I am Email", context);
              },
              icon: const Icon(Icons.email)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          MySnackBar("I am floating action button", context);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.message), label: "Contact"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: "Profile"),
        ],
        onTap: (int index) {
          if (index == 0) {
            MySnackBar("I am Home bottom menu", context);
          }
          if (index == 1) {
            MySnackBar("I am Contact bottom menu", context);
          }
          if (index == 2) {
            MySnackBar("I am Profile bottom menu", context);
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
                accountName: const Text("Md Towhid Alam",
                    style: TextStyle(color: Colors.black)),
                accountEmail: const Text("towhid@gmail.com",
                    style: TextStyle(color: Colors.black)),
                currentAccountPicture:
                Image.network("https://i.postimg.cc/258wCH8j/man.png"),
                onDetailsPressed: () {
                  MySnackBar("This is my profile", context);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                MySnackBar("I am Home", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text("Contact"),
              onTap: () {
                MySnackBar("I am Contact", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                MySnackBar("I am Profile", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              onTap: () {
                MySnackBar("I am Email", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Phone"),
              onTap: () {
                MySnackBar("I am Phone", context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: MyItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
          onTap: (){MySnackBar(context,MyItems[index]["title"]);},
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              height: 250,
              child: Image.network(MyItems[index]["img"]!,fit: BoxFit.fill,),
            ),
          );
        },
      ),


    );
  }
}
