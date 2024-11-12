import 'dart:typed_data';

import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:point_of_sale/model/BranchModel.dart';
import 'package:point_of_sale/model/CategoryModel.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/model/SupplierModel.dart';
import 'package:point_of_sale/service/BranchService.dart';
import 'package:point_of_sale/service/CategoryService.dart';
import 'package:point_of_sale/service/ProductService.dart';
import 'package:point_of_sale/service/SupplierService.dart';
import 'AllProductView.dart'; // Import the AllProductView page

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _imageData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  DateTime? selectedManufactureDate;
  DateTime? selectedExpiryDate;

  List<Category> categories = [];
  List<Supplier> suppliers = [];
  List<Branch> branches = [];

  Category? selectedCategory;
  Supplier? selectedSupplier;
  Branch? selectedBranch;

  Future<void> _pickImage() async {
    if (foundation.kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          _imageData = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _imageFile = pickedImage;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      categories = await CategoryService().fetchCategories();
      suppliers = await SupplierService().fetchSuppliers();
      branches = await BranchService().fetchBranches();

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dropdown data: ${e.toString()}')),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && (_imageFile != null || _imageData != null)) {
      final product = Product(
        id: 0,
        name: _nameController.text,
        unitprice: int.parse(_unitPriceController.text),
        stock: int.parse(_stockController.text),
        manufactureDate: selectedManufactureDate != null
            ? selectedManufactureDate!.toIso8601String()
            : '',
        expiryDate: selectedExpiryDate != null
            ? selectedExpiryDate!.toIso8601String()
            : '',
        photo: '',
        category: selectedCategory,
        supplier: selectedSupplier,
        branch: selectedBranch,
      );

      try {
        await ProductService().createProduct(product, _imageFile, _imageData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );

        // Navigate to AllProductView after successfully saving the product
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllProductView()),
        );

        // Clear form fields and reset image
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
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter product name'
                    : null,
              ),
              TextFormField(
                controller: _unitPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Unit Price'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter Unit price' : null,
              ),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stock'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter Stock' : null,
              ),
              DateTimeFormField(
                decoration:
                const InputDecoration(labelText: 'Manufacture Date'),
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
              DropdownButtonFormField<Category>(
                onChanged: (value) => setState(() => selectedCategory = value),
                items: categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.categoryname ?? 'Unknown Category'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Supplier>(
                onChanged: (value) => setState(() => selectedSupplier = value),
                items: suppliers.map((supplier) {
                  return DropdownMenuItem<Supplier>(
                    value: supplier,
                    child: Text(supplier.name ?? 'Unknown Supplier'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Supplier Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Branch>(
                onChanged: (value) => setState(() => selectedBranch = value),
                items: branches.map((branch) {
                  return DropdownMenuItem<Branch>(
                    value: branch,
                    child: Text(branch.branchName ?? 'Unknown Branch'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Branch Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              SizedBox(height: 20),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
                onPressed: _pickImage,
              ),
              if (_imageData != null)
                Image.memory(_imageData!, height: 150, fit: BoxFit.cover),
              SizedBox(height: 16),
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
