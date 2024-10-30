import 'package:flutter/material.dart';
import 'package:point_of_sale/page/branch/AllBranchView.dart';
import 'package:point_of_sale/service/BranchService.dart';


class CreateBranch extends StatefulWidget {
  const CreateBranch({super.key});

  @override
  State<CreateBranch> createState() => _CreateBranchState();
}

class _CreateBranchState extends State<CreateBranch> {

  final TextEditingController branchName = TextEditingController();
  final TextEditingController branchLocation = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final CreateBranchService branchService = CreateBranchService();


  void _createBranch() async {
    if (_formKey.currentState!.validate()) {
      String bName = branchName.text;
      String blocation = branchLocation.text;


      final response = await branchService.createBranch(bName, blocation);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Branch created successfully!');
        branchName.clear();
        branchLocation.clear();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllBranchesView()),
        );
      } else if (response.statusCode == 409) {
        print('Supplier already exists!');
      } else {
        print('Supplier creation failed with status: ${response.statusCode}');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Branch')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: branchName,
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home_filled),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Branch name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: branchLocation,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Branch Location';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createBranch,
                  child: Text(
                    "Create Supplier", // Updated button text
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