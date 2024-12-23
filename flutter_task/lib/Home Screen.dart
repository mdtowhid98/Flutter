import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search address...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [Icon(Icons.notifications, color: Colors.black)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Near from you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Image.asset('assets/house.jpg', height: 100, width: 150),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Dreamsville House'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Best for you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset('assets/house.jpg', height: 50),
                    title: Text('Orchid House'),
                    subtitle: Text('Rp. 2,500,000 / Year'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
