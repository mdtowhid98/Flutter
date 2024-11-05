import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/service/SalesService.dart';

class CreateSales extends StatefulWidget {
  const CreateSales({super.key});

  @override
  State<CreateSales> createState() => _CreateSalesState();
}

class _CreateSalesState extends State<CreateSales> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();

  DateTime? salesDate = DateTime.now(); // Set default to current date
  List<Product> products = []; // List to hold products
  Product? selectedProduct;

  final _formKey = GlobalKey<FormState>();
  final CreateSalesService salesService = CreateSalesService();

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the widget initializes
    quantityController.addListener(_updateTotalPrice); // Add listener to quantity field
  }

  @override
  void dispose() {
    quantityController.removeListener(_updateTotalPrice); // Remove listener
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    products = await salesService.fetchProducts();
    setState(() {}); // Refresh the UI after fetching products
  }

  void _updateTotalPrice() {
    if (selectedProduct != null && quantityController.text.isNotEmpty) {
      double unitPrice = (selectedProduct!.unitprice ?? 0).toDouble();
      int quantity = int.tryParse(quantityController.text) ?? 0;
      double totalPrice = unitPrice * quantity;
      totalPriceController.text = totalPrice.toStringAsFixed(2); // Format to 2 decimal places
    }
  }

  void _onProductSelected(Product? product) {
    setState(() {
      selectedProduct = product;
      unitPriceController.text = product?.unitprice?.toString() ?? ''; // Update unit price
      _updateTotalPrice(); // Update total price when product changes
    });
  }

  void _createSales() async {
    if (_formKey.currentState!.validate() && salesDate != null) {
      String customerName = customerNameController.text;
      double totalPrice = double.parse(totalPriceController.text); // Parse as double
      int quantity = int.parse(quantityController.text);
      List<Product> selectedProducts = selectedProduct != null ? [selectedProduct!] : [];

      final response = await salesService.createSales(
        customerName,
        salesDate!,
        totalPrice as int,
        quantity,
        selectedProducts,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Sales created successfully!');
        customerNameController.clear();
        totalPriceController.clear();
        quantityController.clear();
        unitPriceController.clear(); // Clear unit price field
        setState(() {
          salesDate = DateTime.now();
          selectedProduct = null;
        });
      } else {
        print('Sales creation failed with status: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Sales')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DateTimeFormField(
                  initialValue: salesDate,
                  decoration: const InputDecoration(
                    labelText: 'Sales Date',
                    border: OutlineInputBorder(),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      salesDate = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<Product>(
                  value: selectedProduct,
                  onChanged: _onProductSelected,
                  decoration: InputDecoration(
                    labelText: 'Product',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: products.map<DropdownMenuItem<Product>>((Product product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text(product.name ?? ''),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a product';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: unitPriceController,
                  decoration: InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: totalPriceController,
                  decoration: InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.price_check),
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createSales,
                  child: Text(
                    "Create Sales",
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
