import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/page/Sales/AllSalesView.dart';
import 'package:point_of_sale/page/invoice/DhanmondiBranchInvoice.dart';
import 'package:point_of_sale/service/ProductService.dart';
import 'package:point_of_sale/service/SalesService.dart';


class CreateSales extends StatefulWidget {
  @override
  _CreateSalesState createState() => _CreateSalesState();
}

class _CreateSalesState extends State<CreateSales> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();

  DateTime? salesDate = DateTime.now();
  List<Product> products = [];
  List<Product?> selectedProducts = [null];
  List<TextEditingController> quantityControllers = [TextEditingController()];
  List<TextEditingController> unitPriceControllers = [TextEditingController()];

  final _formKey = GlobalKey<FormState>();
  final CreateSalesService salesService = CreateSalesService();
  final ProductService productService = ProductService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAllDhanmondiBranchProducts();
    quantityControllers.forEach((controller) {
      controller.addListener(_updateTotalPrice);
    });
  }

  @override
  void dispose() {
    quantityControllers.forEach((controller) {
      controller.removeListener(_updateTotalPrice);
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> _getAllDhanmondiBranchProducts() async {
    try {
      products = await productService.getAllDhanmondiBranchProducts();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching Dhanmondi branch products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < selectedProducts.length; i++) {
      final selectedProduct = selectedProducts[i];
      final quantityText = quantityControllers[i].text;
      final unitPrice = (selectedProduct?.unitprice ?? 0).toDouble();
      final quantity = int.tryParse(quantityText) ?? 0;
      totalPrice += unitPrice * quantity;
    }
    totalPriceController.text = totalPrice.toStringAsFixed(2);
  }

  void _onProductSelected(Product? product, int index) {
    setState(() {
      selectedProducts[index] = product;
      unitPriceControllers[index].text = product?.unitprice?.toString() ?? '';
      _updateTotalPrice();
    });
  }

  void _addProductField() {
    setState(() {
      selectedProducts.add(null);
      quantityControllers.add(TextEditingController()..addListener(_updateTotalPrice));
      unitPriceControllers.add(TextEditingController());
    });
  }

  bool _validateQuantities() {
    for (int i = 0; i < selectedProducts.length; i++) {
      final selectedProduct = selectedProducts[i];
      final quantityText = quantityControllers[i].text;
      final quantity = int.tryParse(quantityText) ?? 0;

      if (selectedProduct != null && (selectedProduct.stock ?? 0) < quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Requested quantity for ${selectedProduct.name} exceeds available stock (${selectedProduct.stock ?? 0}).',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _createSales() async {
    if (_formKey.currentState!.validate() && salesDate != null && _validateQuantities()) {
      String customerName = customerNameController.text;
      double totalPrice = double.parse(totalPriceController.text);
      List<Map<String, dynamic>> productsToSubmit = [];

      for (int i = 0; i < selectedProducts.length; i++) {
        if (selectedProducts[i] != null) {
          productsToSubmit.add({
            'name': selectedProducts[i]!.name,
            'quantity': int.tryParse(quantityControllers[i].text) ?? 0,
            'unitprice': selectedProducts[i]!.unitprice,
          });
        }
      }

      final nonNullSelectedProducts = selectedProducts.whereType<Product>().toList();

      final saleData = {
        'customername': customerName,
        'salesdate': salesDate!.toIso8601String(),
        'totalprice': totalPrice,
        'product': productsToSubmit,
      };

      final response = await salesService.createSales(
        customerName,
        salesDate!,
        totalPrice.toInt(),
        productsToSubmit.length,
        nonNullSelectedProducts,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoicePage(sale: saleData),
          ),
        );

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewSales(),
        //   ),
        // );

        customerNameController.clear();
        totalPriceController.clear();
        for (final controller in quantityControllers) {
          controller.clear();
        }
        setState(() {
          salesDate = DateTime.now();
          selectedProducts = [null];
          quantityControllers = [TextEditingController()];
          unitPriceControllers = [TextEditingController()];
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
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
                ...List.generate(selectedProducts.length, (index) {
                  return Column(
                    children: [
                      DropdownButtonFormField<Product>(
                        value: selectedProducts[index],
                        onChanged: (product) => _onProductSelected(product, index),
                        decoration: InputDecoration(
                          labelText: 'Product',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: products.map<DropdownMenuItem<Product>>((Product product) {
                          return DropdownMenuItem<Product>(
                            value: product,
                            child: Text('${product.name} (Stock: ${product.stock})'),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a product';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: unitPriceControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Unit Price',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: quantityControllers[index],
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
                          final quantity = int.tryParse(value);
                          if (quantity == null || quantity <= 0) {
                            return 'Enter a valid quantity';
                          }
                          final selectedProduct = selectedProducts[index];
                          if (selectedProduct != null && quantity > (selectedProduct.stock ?? 0)) {
                            return 'Exceeds stock quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
                TextFormField(
                  controller: totalPriceController,
                  decoration: InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.price_check),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addProductField,
                  child: Text("Add Product"),
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