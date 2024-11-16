import 'package:flutter/material.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:point_of_sale/service/SalesService.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomerReports extends StatefulWidget {
  @override
  _CustomerReportsState createState() => _CustomerReportsState();
}

class _CustomerReportsState extends State<CustomerReports> {
  final SalesService salesService = SalesService();
  List<Sale> sales = [];
  int? _hoveredIndex; // Track the hovered card's index

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    try {
      final salesData = await salesService.getAllSales();
      setState(() {
        sales = salesData;
      });
    } catch (error) {
      print('Error loading sales: $error');
    }
  }

  // Function to calculate total sales per customer
  Map<String, double> getCustomerTotalSales() {
    Map<String, double> customerTotalSales = {};
    for (var sale in sales) {
      if (sale.customername != null) {
        customerTotalSales[sale.customername!] =
            (customerTotalSales[sale.customername!] ?? 0) + (sale.totalprice ?? 0);
      }
    }
    return customerTotalSales;
  }

  // Function to determine the star rating based on total price
  int getStarRating(double totalPrice) {
    if (totalPrice > 2000) {
      return 5;
    } else if (totalPrice > 1500) {
      return 4;
    } else if (totalPrice > 1000) {
      return 3;
    } else if (totalPrice > 500) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerTotalSales = getCustomerTotalSales();

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Sales Report'),
      ),
      body: Column(
        children: [
          if (sales.isEmpty)
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Row(
                children: [
                  // Pie chart section
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: customerTotalSales.entries.map((entry) {
                          final color = Colors.primaries[entry.key.hashCode % Colors.primaries.length];
                          bool isHovered = _hoveredIndex != null && customerTotalSales.keys.toList()[_hoveredIndex!] == entry.key;
                          return PieChartSectionData(
                            color: color,
                            value: entry.value,
                            radius: 50,
                            // Remove the title to not display total price
                            titleStyle: TextStyle(
                              fontSize: 0, // Set font size to 0 to hide the title
                            ),
                            // Highlight the section border when the card is hovered
                            borderSide: isHovered ? BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  // Legends (side color symbols and customer names)
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: customerTotalSales.entries.map((entry) {
                        final color = Colors.primaries[entry.key.hashCode % Colors.primaries.length];
                        return Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: color,
                            ),
                            SizedBox(width: 8),
                            Text('${entry.key}'), // Only display customer name
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                int starRating = getStarRating(sale.totalprice?.toDouble() ?? 0.0);

                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _hoveredIndex = index;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _hoveredIndex = null;
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: _hoveredIndex == index ? Colors.blue : Colors.transparent, // Change border color on hover
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      title: Text('Customer: ${sale.customername}'),
                      subtitle: Text('Total Price: \$${sale.totalprice}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(starRating, (index) {
                          return Icon(
                            Icons.star,
                            color: Colors.redAccent,
                            size: 20,
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
