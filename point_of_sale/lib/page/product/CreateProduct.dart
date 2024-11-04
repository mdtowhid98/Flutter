import 'dart:typed_data';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_of_sale/model/BranchModel.dart';
import 'package:point_of_sale/model/CategoryModel.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/model/SupplierModel.dart';
import 'package:point_of_sale/service/BranchService.dart';
import 'package:point_of_sale/service/CategoryService.dart';
import 'package:point_of_sale/service/ProductService.dart';
import 'package:point_of_sale/service/SupplierService.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile; // Use XFile for consistency with image_picker
  Uint8List? _imageData; // To hold image data as Uint8List

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  DateTime? selectedManufactureDate;
  DateTime? selectedExpiryDate;

  List<Category> categories = [];
  List<Supplier> suppliers = [];
  List<Branch> branches = [];

  String? selectedCategory;
  String? selectedSupplier;
  String? selectedBranch;

  // Pick an image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Read the image as bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile; // Assign the picked file
          _imageData = bytes; // Store the image data
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDropdownData(); // Load data for dropdowns on page load
  }

  Future<void> _fetchDropdownData() async {
    try {
      // Assuming ProductService provides methods to get these lists
      categories = await CategoryService().fetchCategories();
      suppliers = await SupplierService().fetchSuppliers();
      branches = await BranchService().fetchBranches();

      setState(
              () {}); // Update the state to refresh the UI with the fetched data
    } catch (e) {
      print('Error fetching dropdown data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dropdown data: ${e.toString()}')),
      );
    }
  }


  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final product = Product(
        name: _nameController.text,
        unitprice: int.parse(_unitPriceController.text),
        stock: int.parse(_stockController.text),
        manufactureDate: selectedManufactureDate?.toIso8601String() ?? '',
        expiryDate: selectedExpiryDate?.toIso8601String() ?? '',
        photo: '',
        // will be managed by backend
        category: categories.firstWhere(
                (category) => category.categoryname == selectedCategory,
            orElse: () => Category()),
        supplier: suppliers.firstWhere(
                (supplier) => supplier.name == selectedSupplier,
            orElse: () => Supplier()),
        branch: branches.firstWhere(
                (branch) => branch.branchName == selectedBranch,
            orElse: () => Branch()),
      );

      try {
        await ProductService().createProduct(product, _imageFile!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );

        // Clear form fields and reset image
        _formKey.currentState!.reset();
        _nameController.clear();
        _unitPriceController.clear();
        _stockController.clear();
        _imageFile = null;
        _imageData = null;
        selectedManufactureDate = null;
        selectedExpiryDate = null;
        selectedCategory = null;
        selectedSupplier = null;
        selectedBranch = null;
        setState(() {}); // Refresh the state
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  // Additional validators for dropdowns
  String? validateDropdown(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Select $label';
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Enter product name'
                    : null,
              ),

              // Unit Price
              TextFormField(
                controller: _unitPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Unit Price'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Enter Unit price'
                    : null,
              ),

              // Stock
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stock'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Enter Stock'
                    : null,
              ),

              // Manufacture Date
              DateTimeFormField(
                decoration: const InputDecoration(
                    labelText: 'Manufacture Date'),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedManufactureDate = value;
                  });
                },
              ),

              // Expiry Date
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Expiry Date'),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedExpiryDate = value;
                  });
                },
              ),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                validator: (value) => validateDropdown(value, 'Category'),
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: categories.map<DropdownMenuItem<String>>((
                    Category category) {
                  return DropdownMenuItem<String>(
                    value: category.categoryname,
                    child: Text(category.categoryname ?? ''),
                  );
                }).toList(),
              ),

              // Supplier Dropdown
              DropdownButtonFormField<String>(
                value: selectedSupplier,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSupplier = newValue;
                  });
                },
                validator: (value) => validateDropdown(value, 'Supplier'),
                decoration: InputDecoration(
                  labelText: 'Supplier Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: suppliers.map<DropdownMenuItem<String>>((
                    Supplier supplier) {
                  return DropdownMenuItem<String>(
                    value: supplier.name,
                    child: Text(supplier.name ?? ''),
                  );
                }).toList(),
              ),

              // Branch Dropdown
              DropdownButtonFormField<String>(
                value: selectedBranch,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBranch = newValue;
                  });
                },
                validator: (value) => validateDropdown(value, 'Branch'),
                decoration: InputDecoration(
                  labelText: 'Branch Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: branches.map<DropdownMenuItem<String>>((Branch branch) {
                  return DropdownMenuItem<String>(
                    value: branch.branchName,
                    child: Text(branch.branchName ?? 'Unknown Branch'),
                  );
                }).toList(),
              ),

              // Image Picker
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
                onPressed: _pickImage,
              ),

              if (_imageData != null)
                Column(
                  children: [
                    Image.memory(_imageData!, height: 150, fit: BoxFit.cover),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _imageData = null;
                          _imageFile = null;
                        });
                      },
                    ),
                  ],
                ),

              // Save Product Button
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
