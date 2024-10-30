import 'dart:convert';
import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup_spring/model/Branch.dart';
import 'package:signup_spring/model/Category.dart';
import 'package:signup_spring/model/Product.dart';
import 'package:signup_spring/model/Supplier.dart';
import 'package:signup_spring/service/Branch_Service.dart';
import 'package:signup_spring/service/Category_Service.dart';

import 'package:signup_spring/service/Product_Service.dart';
import 'package:signup_spring/service/Supplier_Service.dart';
// import 'package:signup_spring/service/CreateProductService.dart'; // Ensure this import is correct
import 'package:signup_spring/page/All_Product_view.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final TextEditingController productNameController = TextEditingController();
  File? photoFile;
  final TextEditingController stockController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();

  DateTime? selectedManufactureDate;
  DateTime? selectedExpiryDate;

  final _formKey = GlobalKey<FormState>();
  // final CreateProductService createProductService = CreateProductService();
  final CreateProductService createProductService=CreateProductService()
  ;

  List<Category> categories = [];
  List<Supplier> suppliers = [];
  List<Branch> branches = [];

  String? selectedCategory;
  String? selectedSupplier;
  String? selectedBranch;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      categories = await CategoryService().fetchCategories();
      suppliers = await SupplierService().fetchSuppliers();
      branches = await BranchService().fetchBranches();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  void _clearFields() {
    productNameController.clear();
    photoFile = null;
    stockController.clear();
    quantityController.clear();
    unitPriceController.clear();
    selectedManufactureDate = null;
    selectedExpiryDate = null;
    selectedCategory = null;
    selectedSupplier = null;
    selectedBranch = null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photoFile = File(pickedFile.path);
      });
    }
  }

  void _createProduct() async {
    if (_formKey.currentState!.validate()) {
      if (photoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a photo')),
        );
        return;
      }

      String pName = productNameController.text;
      int pStock = int.parse(stockController.text);
      int pQuantity = int.parse(quantityController.text);
      int pUnitPrice = int.parse(unitPriceController.text);
      String pManufactureDate = selectedManufactureDate?.toIso8601String() ?? '';
      String pExpiryDate = selectedExpiryDate?.toIso8601String() ?? '';

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        final response = await createProductService.createProduct(
          Product(
            name: pName,
            photo: photoFile!.path,
            stock: pStock,
            quantity: pQuantity,
            unitprice: pUnitPrice,
            manufactureDate: pManufactureDate,
            expiryDate: pExpiryDate,
            category: categories.firstWhere((cat) => cat.categoryname == selectedCategory),
            supplier: suppliers.firstWhere((sup) => sup.name == selectedSupplier),
            branch: branches.firstWhere((bra) => bra.branchName == selectedBranch),
          ),
          photoFile,
        );

        Navigator.pop(context); // Close loading indicator

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product created successfully!')),
        );
        _clearFields();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllProductView()),
        );
      } catch (error) {
        Navigator.pop(context); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits_outlined),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter product name' : null,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.photo_library, size: 25, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          photoFile == null ? 'Browse Your Photo' : 'Photo Selected',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.storage),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter stock' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits_outlined),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter quantity' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: unitPriceController,
                  decoration: InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.price_check),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter unit price' : null,
                ),
                SizedBox(height: 20),
                DateTimeFormField(
                  decoration: const InputDecoration(labelText: 'Manufacture Date'),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedManufactureDate = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DateTimeFormField(
                  decoration: const InputDecoration(labelText: 'Expiry Date'),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedExpiryDate = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categories.map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.categoryname,
                      child: Text(category.categoryname ?? ''),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedSupplier,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSupplier = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Supplier Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: suppliers.map<DropdownMenuItem<String>>((Supplier supplier) {
                    return DropdownMenuItem<String>(
                      value: supplier.name,
                      child: Text(supplier.name ?? ''),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedBranch,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBranch = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: branches.map<DropdownMenuItem<String>>((Branch branch) {
                    return DropdownMenuItem<String>(
                      value: branch.branchName,
                      child: Text(branch.branchName ?? ''),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createProduct,
                  child: Text(
                    "Create Product",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
