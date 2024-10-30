import 'package:flutter/material.dart';
import 'package:point_of_sale/model/BranchModel.dart';
import 'package:point_of_sale/page/branch/CreateBranch.dart';
import 'package:point_of_sale/service/BranchService.dart';


class AllBranchesView extends StatefulWidget {
  const AllBranchesView({super.key});

  @override
  State<AllBranchesView> createState() => _AllBranchesViewState();
}

class _AllBranchesViewState extends State<AllBranchesView> {
  late Future<List<Branch>> futureBranches;

  @override
  void initState() {
    super.initState();
    futureBranches = BranchService().fetchBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branches'),
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
                  MaterialPageRoute(builder: (context) => CreateBranch()), // Adjust this to your CreateBranch widget
                );
              },
              child: Text('Create Branch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Branch>>(
              future: futureBranches,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No branches available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final branch = snapshot.data![index];
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
                              Text(
                                'ID: ${branch.id ?? 'Unnamed ID'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Branch Name: ${branch.branchName ?? 'No branch available'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Location: ${branch.location ?? 'No location available'}',
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
