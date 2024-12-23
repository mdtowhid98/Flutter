import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/house.jpg'),
              SizedBox(height: 20),
              Text(
                'Dreamsville House',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('JL. Sultan Iskandar Muda, Jakarta Selatan'),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.bed),
                  SizedBox(width: 10),
                  Text('6 Bedroom'),
                  SizedBox(width: 20),
                  Icon(Icons.bathtub),
                  SizedBox(width: 10),
                  Text('4 Bathroom'),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                  'This house has a modern design, a large pool, and a garage for four cars.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Rent Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
