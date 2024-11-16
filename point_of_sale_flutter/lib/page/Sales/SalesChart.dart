import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:point_of_sale/service/SalesService.dart';

class SalesChart extends StatefulWidget {
  @override
  _SalesChartState createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  final SalesService salesService = SalesService();
  Map<String, double> groupedSales = {};
  DateTimeRange? selectedDateRange;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    try {
      final salesData = await salesService.getAllSales();
      if (selectedDateRange != null) {
        // Filter sales data based on selected date range
        salesData.removeWhere((sale) => sale.salesdate == null ||
            sale.salesdate!.isBefore(selectedDateRange!.start) ||
            sale.salesdate!.isAfter(selectedDateRange!.end));
      }
      updateGroupedSales(salesData);
    } catch (error) {
      print('Error loading sales: $error');
    }
  }

  void updateGroupedSales(List<Sale> salesData) {
    final Map<String, double> salesByDate = {};
    for (var sale in salesData) {
      if (sale.salesdate != null) {
        String dateKey = DateFormat('yyyy-MM-dd').format(sale.salesdate!);
        salesByDate[dateKey] =
            (salesByDate[dateKey] ?? 0) + (sale.totalprice ?? 0).toDouble();
      }
    }
    setState(() {
      groupedSales = salesByDate;
    });
  }

  double calculateInterval() {
    if (groupedSales.isEmpty) return 10;
    double maxValue = groupedSales.values.reduce((a, b) => a > b ? a : b);
    // Calculate interval to ensure consistent scale for Y-axis
    return (maxValue / 5).ceilToDouble();
  }

  void scrollChart(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Chart'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Colors.blue, Colors.amberAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select Date Range: '),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDateRange) {
                      setState(() {
                        selectedDateRange = picked;
                      });
                      loadSales();
                    }
                  },
                ),
              ],
            ),
          ),
          // Scroll buttons placed under the date range picker
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {
                    scrollChart(-100); // Scroll left by 100 pixels
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    scrollChart(100); // Scroll right by 100 pixels
                  },
                ),
              ],
            ),
          ),
          Divider(),
          groupedSales.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: groupedSales.length * 80.0, // Adjusted width per bar
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    barGroups: groupedSales.entries
                        .map((entry) {
                      int index = groupedSales.keys
                          .toList()
                          .indexOf(entry.key);
                      Color barColor = Colors.primaries[
                      index % Colors.primaries.length];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            color: barColor,
                            width: 35, // Slightly wider bars
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              color: Colors.grey.withOpacity(0.3), // Light background for the bars
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: calculateInterval(),
                          getTitlesWidget: (value, meta) {
                            // Round the value to the nearest integer
                            String roundedValue = value.toInt().toString(); // Rounds to the nearest integer
                            return Text(
                              roundedValue,
                              style: TextStyle(fontSize: 12), // Adjust font size as needed
                            );
                          },
                          reservedSize: 40, // Ensure space for the left titles
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < groupedSales.keys.length) {
                              String dateLabel = groupedSales.keys.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  dateLabel,
                                  style: TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }
                            return Text('');
                          },
                          reservedSize: 50,
                          interval: 1,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: true),
                    gridData: FlGridData(show: true),
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: groupedSales.length,
              itemBuilder: (context, index) {
                String date = groupedSales.keys.elementAt(index);
                double totalPrice = groupedSales[date]!;
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Date: $date'),
                    subtitle: Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
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
