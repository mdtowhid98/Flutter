import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final TextEditingController categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heading
            Text(
              "Create a New Category",
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
              controller: categoryName,
              decoration: InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.category),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                String category = categoryName.text;
                print('Category Name: $category');
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
