import 'package:flutter/material.dart';
import 'package:point_of_sale/model/SupplierModel.dart';
import 'package:point_of_sale/page/supplier/CreateSupplier.dart';
import 'package:point_of_sale/service/SupplierService.dart';


class AllSupplierView extends StatefulWidget {
  const AllSupplierView({super.key});

  @override
  State<AllSupplierView> createState() => _AllSupplierViewState();
}

class _AllSupplierViewState extends State<AllSupplierView> {
  late Future<List<Supplier>> futureSuppliers;

  @override
  void initState() {
    super.initState();
    futureSuppliers = SupplierService().fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateSupplier()), // Adjust this to your CreateSupplier widget
                );
              },
              child: Text('Create Supplier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Supplier>>(
              future: futureSuppliers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No suppliers available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final supplier = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${supplier.id ?? 'Unnamed ID'}',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(
                                'Supplier Name: ${supplier.name ?? 'No supplier available'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Email: ${supplier.email ?? 'No email available'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Cell: ${supplier.cell ?? 'No cell available'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Address: ${supplier.address ?? 'No address available'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
