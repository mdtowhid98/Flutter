import 'dart:async';
import 'package:flutter/material.dart';
import 'package:point_of_sale/page/Sales/CreateSalesBananiBranch.dart';
import 'package:point_of_sale/page/Sales/CustomerReoprts.dart';
import 'package:point_of_sale/page/Sales/SalesChart.dart';
import 'package:point_of_sale/page/Sales/SalesDetails.dart';
import 'package:point_of_sale/page/UserRole.dart';
import 'package:point_of_sale/page/product/StockListBanani.dart';

class HomePageBananiBranch extends StatefulWidget {
  const HomePageBananiBranch({super.key});

  @override
  _HomePageBananiBranchState createState() => _HomePageBananiBranchState();
}

class _HomePageBananiBranchState extends State<HomePageBananiBranch> {
  final List<Map<String, String>> myItems = [
    {
      "img": "https://cdn-icons-png.flaticon.com/128/15917/15917216.png",
      "title": "Banani Branch Stock List"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/3211/3211610.png",
      "title": "Sale"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/6632/6632834.png",
      "title": "Sales Details"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/3258/3258522.png",
      "title": "Sales Chart"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/17718/17718145.png",
      "title": "User Role"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/17783/17783610.png",
      "title": "Customer Reports"
    },
  ];

  final List<String> _carouselImages = [
    "https://media.istockphoto.com/id/1220303230/vector/social-distancing-during-the-covid-19-pandemic.jpg?s=612x612&w=0&k=20&c=I7Xv5ZAEeL4BYKvj_Ta9_W_D2k17h_VS3mgQhjaDl_4=",
    "https://media.istockphoto.com/id/1227011225/vector/people-in-protective-masks-are-in-the-queue-to-the-cashier-keeping-social-distance-safe.jpg?s=612x612&w=0&k=20&c=XnRL2Fd_w_GIQF-kLw99ScXxLAJaMov_V2cMIC4adQI=",
    "https://media.istockphoto.com/id/1219131407/vector/safe-grocery-shopping-during-coronavirus-epidemic.jpg?s=612x612&w=0&k=20&c=u6NU2xwygGanSEZvypjRhbLanlvG6TeUo9a2tyKr6Vc="
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Auto-scroll carousel every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % _carouselImages.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousImage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _goToNextImage() {
    if (_currentPage < _carouselImages.length - 1) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Towhid Medical Banani Branch'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.lightGreenAccent, Colors.yellowAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Image Carousel
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _carouselImages.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          _carouselImages[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                // Left Button
                // Positioned(
                //   left: 10,
                //   child: IconButton(
                //     onPressed: _goToPreviousImage,
                //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                //   ),
                // ),
                // Right Button
                // Positioned(
                //   right: 10,
                //   child: IconButton(
                //     onPressed: _goToNextImage,
                //     icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _carouselImages.map((url) {
                int index = _carouselImages.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.orange : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            // GridView with Hover Animation
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  return HoverCard(
                    imgUrl: myItems[index]["img"]!,
                    title: myItems[index]["title"]!,
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AllProductStockBanani()),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateSalesBananiBranch()),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewSalesDetailsScreen()),
                        );
                      } else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SalesChart()),
                        );
                      } else if (index == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserRole()),
                        );
                      } else if (index == 5) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CustomerReports()),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final String imgUrl;
  final String title;
  final VoidCallback onTap;

  const HoverCard({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color _borderColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _borderColor = Colors.blue;
        });
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _borderColor = Colors.transparent;
        });
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            color: Colors.lightGreenAccent,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: _borderColor, width: 2),
              ),
              child: SizedBox(
                width: 100,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      widget.imgUrl,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
