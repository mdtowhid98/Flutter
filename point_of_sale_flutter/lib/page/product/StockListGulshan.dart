import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/service/ProductService.dart';

class AllProductStockGulshan extends StatefulWidget with WidgetsBindingObserver {
  const AllProductStockGulshan({super.key});

  @override
  State<AllProductStockGulshan> createState() => _AllProductStockGulshanState();
}

class _AllProductStockGulshanState extends State<AllProductStockGulshan> {
  late Future<List<Product>> futureProducts;
  Map<int, bool> hoverStates = {};

  final List<Color> cardColors = [
    Colors.amber.shade100,
    Colors.lightBlue.shade100,
    Colors.lightGreen.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
    Colors.yellow.shade100,
    Colors.orange.shade100,
  ];

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().getAllGulshanBranchProducts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      futureProducts = ProductService().getAllGulshanBranchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.lightGreenAccent, Colors.yellowAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            // Prepare data for the pie chart, calculating stock per product
            Map<String, double> stockData = {};
            snapshot.data!.forEach((product) {
              final productName = product.name ?? 'Unknown Product';
              stockData[productName] = (stockData[productName] ?? 0) + (product.stock ?? 0);
            });

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: stockData.entries.map((entry) {
                          int colorIndex = stockData.keys.toList().indexOf(entry.key) % cardColors.length;
                          return PieChartSectionData(
                            color: cardColors[colorIndex],
                            value: entry.value,
                            // Show only stock value in the pie chart title
                            title: '${entry.value.toInt()}',
                            radius: 50,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                      ),
                    ),
                  ),
                ),
                // Display product names and color symbols beside the pie chart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: stockData.entries.map((entry) {
                      int colorIndex = stockData.keys.toList().indexOf(entry.key) % cardColors.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: cardColors[colorIndex],
                            ),
                            SizedBox(width: 10),
                            Text(
                              entry.key, // Display product name
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      final backgroundColor = cardColors[index % cardColors.length];

                      return MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            hoverStates[index] = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            hoverStates[index] = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(
                              color: hoverStates[index] ?? false ? Colors.lime : Colors.blue,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product Name: ${product.name ?? 'N/A'}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Stock: ${product.stock ?? 'N/A'}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Branch: ${product.branch?.branchName ?? 'Unknown Branch'}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
