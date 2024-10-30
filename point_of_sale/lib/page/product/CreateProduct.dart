import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/page/product/AllProductView.dart';
import 'package:point_of_sale/service/ProductService.dart';


class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController photo = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController unitPrice = TextEditingController();
  final TextEditingController categoryname = TextEditingController();
  final TextEditingController supplierName = TextEditingController();
  final TextEditingController branchName = TextEditingController();

  DateTime? selectedManufactureDate;
  DateTime? selectedExpiryDate;

  final _formKey = GlobalKey<FormState>();
  final CreateProductService productService = CreateProductService();

  void _createProduct() async {
    if (_formKey.currentState!.validate()) {
      String pName = productName.text;
      String pPhoto = photo.text;
      int pStock = int.parse(stock.text);
      int pQuantity = int.parse(quantity.text);
      int pUnitPrice = int.parse(unitPrice.text);
      String pManufactureDate = selectedManufactureDate?.toIso8601String() ?? '';
      String pExpiryDate = selectedExpiryDate?.toIso8601String() ?? '';
      String pCategoryName = categoryname.text;
      String pSupplierName = supplierName.text;
      String pBranchName = branchName.text;

      final response = await productService.createProduct(
        pName,
        pPhoto,
        pStock,
        pQuantity,
        pUnitPrice,
        pManufactureDate,
        pExpiryDate,
        pCategoryName,
        pSupplierName,
        pBranchName,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Product created successfully!');
        // Clear fields
        productName.clear();
        photo.clear();
        stock.clear();
        quantity.clear();
        unitPrice.clear();
        categoryname.clear();
        supplierName.clear();
        branchName.clear();
        selectedManufactureDate = null;
        selectedExpiryDate = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllProductView()),
        );
      } else {
        print('Product creation failed with status: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: productName,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits_outlined),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter product name' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: photo,
                  decoration: InputDecoration(
                    labelText: 'Browse Your Photo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: stock,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.storage),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter stock' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: quantity,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits_outlined),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter quantity' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: unitPrice,
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
                TextFormField(
                  controller: categoryname,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: supplierName,
                  decoration: InputDecoration(
                    labelText: 'Supplier Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.storage),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: branchName,
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home_filled),
                  ),
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