import 'package:flutter/material.dart';
import 'package:point_of_sale/model/CategoryModel.dart';
import 'package:point_of_sale/model/ProductModel.dart';


final List<Category> categories = [];



final List<Product> allProducts = [];



class CreateSalesForm extends StatefulWidget {
  @override
  _CreateSalesFormState createState() => _CreateSalesFormState();
}

class _CreateSalesFormState extends State<CreateSalesForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  DateTime _salesDate = DateTime.now();
  List<ProductItem> _products = [ProductItem()];
  double _totalPrice = 0;

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    double total = 0;
    for (var product in _products) {
      total += product.quantity * product.unitPrice * (1 - product.discount / 100);
    }
    setState(() {
      _totalPrice = total;
    });
  }

  void _addProduct() {
    setState(() {
      _products.add(ProductItem());
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
      _calculateTotalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Customer name is required' : null,
              ),
              ListTile(
                title: Text("Sales Date: ${_salesDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _salesDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _salesDate) {
                    setState(() {
                      _salesDate = pickedDate;
                    });
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return ProductForm(
                      product: _products[index],
                      onRemove: () => _removeProduct(index),
                      onUpdate: _calculateTotalPrice,
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text("Add Product"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Total Price: \$${_totalPrice.toStringAsFixed(2)}"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _calculateTotalPrice();
                    // Submit sales data logic here
                  }
                },
                child: Text("Create Sale"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItem {
  String category = '';
  String name = '';
  double unitPrice = 0;
  int quantity = 1;
  double discount = 0;
}

class ProductForm extends StatefulWidget {
  final ProductItem product;
  final VoidCallback onRemove;
  final VoidCallback onUpdate;

  ProductForm({
    required this.product,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  List<Product> filteredProducts = [];

  void _filterProductsByCategory(String categoryName) {
    setState(() {
      filteredProducts = allProducts.where((product) => product.category?.categoryname == categoryName).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: widget.product.category,
              items: categories.map((category) {
                return DropdownMenuItem(value: category.categoryname, child: Text(category.categoryname!));
              }).toList(),
              onChanged: (value) {
                widget.product.category = value!;
                _filterProductsByCategory(value);
                widget.onUpdate();
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            DropdownButtonFormField<Product>(
              value: null,
              items: filteredProducts.map<DropdownMenuItem<Product>>((product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text('${product.name} (Stock: ${product.stock})'),
                );
              }).toList(),
              onChanged: (value) {
                widget.product.name = value!.name!;
                widget.product.unitPrice = value.unitprice! as double;
                widget.onUpdate();
              },
              decoration: InputDecoration(labelText: 'Product'),
              validator: (value) => value == null ? 'Select a product' : null,
            ),
            TextFormField(
              initialValue: widget.product.quantity.toString(),
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.product.quantity = int.parse(value);
                widget.onUpdate();
              },
            ),
            TextFormField(
              initialValue: widget.product.discount.toString(),
              decoration: InputDecoration(labelText: 'Discount (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.product.discount = double.parse(value);
                widget.onUpdate();
              },
            ),
            IconButton(
              onPressed: widget.onRemove,
              icon: Icon(Icons.remove_circle, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
