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

  Future<void> _pickImage() async {
    if (foundation.kIsWeb) {
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          _imageData = pickedImage; // Store the picked image as Uint8List
        });
      }
    } else {
      // For Mobile: Use image_picker to pick image
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
    if (_formKey.currentState!.validate() && (_imageFile != null || _imageData != null)) {
//save product details
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
        category: Category(),
        supplier: Supplier(),
        branch: Branch(),
      );

      try {
        // Assuming createProduct accepts an XFile; adjust as needed based on your service method
        await ProductService().createProduct(product, _imageFile!, _imageData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
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
        selectedBranch = null; // Reset image data
        setState(() {});
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
                items: categories
                    .map<DropdownMenuItem<String>>((Category category) {
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
                items: suppliers
                    .map<DropdownMenuItem<String>>((Supplier supplier) {
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
                    child: Text(branch.branchName ?? 'Unknown Branch'),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              SizedBox(height: 16),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
                onPressed: _pickImage,
              ),
              if (_imageData != null)
                Image.memory(_imageData!, height: 150, fit: BoxFit.cover),
              // Display image
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
