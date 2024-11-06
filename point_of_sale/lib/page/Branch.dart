import 'package:flutter/material.dart';

class Branch extends StatelessWidget {
  final TextEditingController branchName = TextEditingController();
  final TextEditingController location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Branch"),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heading
            Text(
              "Create a New Branch",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Input Field
            TextField(
              controller: branchName,
              decoration: InputDecoration(
                labelText: "Branch Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.home),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: location,
              decoration: InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.location_city),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // String category = categoryName.text;
                // print('Category Name: $category');
                // You can also handle form submission here
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
