import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/page/invoice/DhanmondiBranchInvoice.dart';
import 'package:point_of_sale/service/SalesService.dart';

class CreateSales extends StatefulWidget {
  const CreateSales({super.key});

  @override
  State<CreateSales> createState() => _CreateSalesState();
}

class _CreateSalesState extends State<CreateSales> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();

  DateTime? salesDate = DateTime.now();
  List<Product> products = [];
  List<Product?> selectedProducts = [null];
  List<TextEditingController> quantityControllers = [TextEditingController()];
  List<TextEditingController> unitPriceControllers = [TextEditingController()];
  List<TextEditingController> stockControllers = [TextEditingController()]; // New controller list for stock

  final _formKey = GlobalKey<FormState>();
  final CreateSalesService salesService = CreateSalesService();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
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

  Future<void> _fetchProducts() async {
    products = await salesService.fetchProducts();
    setState(() {});
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
      stockControllers[index].text = product?.stock?.toString() ?? ''; // Set stock value
      _updateTotalPrice();
    });
  }

  void _addProductField() {
    setState(() {
      selectedProducts.add(null);
      quantityControllers.add(TextEditingController()..addListener(_updateTotalPrice));
      unitPriceControllers.add(TextEditingController());
      stockControllers.add(TextEditingController()); // Add new stock controller
    });
  }

  void _createSales() async {
    if (_formKey.currentState!.validate() && salesDate != null) {
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
        print('Sales created successfully!');

        // Decrement stock for each sold product
        for (int i = 0; i < selectedProducts.length; i++) {
          if (selectedProducts[i] != null) {
            int soldQuantity = int.tryParse(quantityControllers[i].text) ?? 0;
            // Ensure the product ID is not null before updating stock
            int? productId = selectedProducts[i]!.id;
            if (productId != null) {
              // Update the product stock in your backend
              await salesService.updateProductStock(productId, soldQuantity);
            } else {
              print('Product ID is null for product: ${selectedProducts[i]!.name}');
            }
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoicePage(sale: saleData),
          ),
        );

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
          stockControllers = [TextEditingController()]; // Reset stock controllers
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
                      TextFormField(
                        controller: quantityControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.add_shopping_cart),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                            return 'Please enter a valid quantity';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: unitPriceControllers[index],
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Unit Price',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.price_change),
                        ),
                      ),
                      TextFormField(
                        controller: stockControllers[index],
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Stock',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.store),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addProductField,
                  child: Text('Add Another Product'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: totalPriceController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createSales,
                  child: Text('Create Sales'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

