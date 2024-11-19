import 'package:flutter/material.dart';
import 'package:point_of_sale/model/Sale.dart';
import 'package:point_of_sale/service/SalesService.dart';

class CustomerReports extends StatefulWidget {
  @override
  _CustomerReportsState createState() => _CustomerReportsState();
}

class _CustomerReportsState extends State<CustomerReports> with SingleTickerProviderStateMixin {
  final SalesService salesService = SalesService();
  List<Sale> sales = [];
  int? _hoveredIndex; // Track the hovered card's index

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    loadSales();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
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

  // Group sales by customer and calculate total sales for each customer
  Map<String, double> getCustomerTotalSales() {
    Map<String, double> customerTotalSales = {};
    for (var sale in sales) {
      if (sale.customername != null) {
        String customerName = sale.customername!.toLowerCase();
        customerTotalSales[customerName] = (customerTotalSales[customerName] ?? 0) + (sale.totalprice ?? 0);
      }
    }
    return customerTotalSales;
  }

  // Function to determine the star rating based on total price
  int getStarRating(double totalPrice) {
    if (totalPrice > 10000) {
      return 5;
    } else if (totalPrice > 8000) {
      return 4;
    } else if (totalPrice > 5000) {
      return 3;
    } else if (totalPrice > 2000) {
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.lightGreenAccent], // Adjust colors here as needed
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (sales.isEmpty)
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Center( // Center the bar chart
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(200, 200), // Size for the bar chart
                      painter: BarChartPainter(customerTotalSales, _animation.value),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: customerTotalSales.length,
              itemBuilder: (context, index) {
                final customerName = customerTotalSales.keys.elementAt(index);
                final totalPrice = customerTotalSales[customerName] ?? 0;
                int starRating = getStarRating(totalPrice);

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
                      title: Text('Customer: $customerName'),
                      subtitle: Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
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

class BarChartPainter extends CustomPainter {
  final Map<String, double> customerTotalSales;
  final double animationValue;
  final double barGap = 4.0; // Define the gap between bars

  BarChartPainter(this.customerTotalSales, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    double totalSales = customerTotalSales.values.fold(0, (sum, value) => sum + value);
    double barWidth = (size.width - (barGap * (customerTotalSales.length - 1))) / customerTotalSales.length;
    double maxBarHeight = size.height;

    Paint paint = Paint()..style = PaintingStyle.fill;

    double offsetX = 0;

    for (var entry in customerTotalSales.entries) {
      double barHeight = (entry.value / totalSales) * maxBarHeight;
      paint.color = Colors.primaries[entry.key.hashCode % Colors.primaries.length];

      // Animate the bar height based on the animation value
      canvas.drawRect(
        Rect.fromLTWH(offsetX, size.height - (barHeight * animationValue), barWidth, barHeight * animationValue),
        paint,
      );

      offsetX += barWidth + barGap; // Add the gap between bars
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

