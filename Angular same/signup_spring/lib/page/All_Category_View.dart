import 'package:flutter/material.dart';
import 'package:signup_spring/model/Category.dart';
import 'package:signup_spring/page/UpdateCategory.dart';
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

  Future<void> _deleteCategory(Category category) async {
    // Call the delete method from the service
    await CategoryService().deleteCategory(category.id);
    // Refresh the category list
    setState(() {
      futureCategories = CategoryService().fetchCategories();
    });
  }

  void _updateCategory(Category category) {
    // Navigate to an update screen (you'll need to implement this)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateCategoryView(category: category)),
    ).then((_) {
      // Refresh the category list after update
      setState(() {
        futureCategories = CategoryService().fetchCategories();
      });
    });
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
                        'Category Name: ${category.categoryname ?? 'No category available'}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateCategory(category),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete Category'),
                                    content: Text('Are you sure you want to delete this category?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteCategory(category);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
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


