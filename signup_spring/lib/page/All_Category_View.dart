import 'package:flutter/material.dart';
import 'package:signup_spring/model/Category.dart';
import 'package:signup_spring/service/Category_Service.dart';

class AllCategoryView extends StatefulWidget {
  const AllCategoryView({super.key});

  @override
  State<AllCategoryView> createState() => _AllCategoryViewState();
}

class _AllCategoryViewState extends State<AllCategoryView> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Category>>(

        future: futureCategories,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text('ID: ${category.id ?? 'Unnamed ID'}'),
                      subtitle: Text(
                        'Category Name:${category.categoryname ?? 'No category available'}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
