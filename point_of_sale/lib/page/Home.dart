import 'dart:async';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // This is for the BottomNavigationBar
  int _carouselIndex = 0; // This is for the carousel
  late PageController _pageController;
  Timer? _timer;

  final List<String> _texts = [
    "মাসিক ও বার্ষিক প্যাকেজে ব্যাবসার সকল প্রয়োজনীয় \nফিচার নিয়ে দ্রুত ব্যবস্থপনায় এগিয়ে থাকুন।",
    "মাত্র ১৯৯ টাকায় ৬০% ছাড়ে মাসব্যাপি\nস্মাট ম্যানেজমেন্ট আরও সহজ, আরও দ্রুত।",
    "সারা বছরের নিশ্চিত ব্যাবস্থাপনা মাত্র ১৯৯ টাকায় \n৮০% ছাড়ে ব্যাবসার উন্নয়নে ফ্রী সব ফিচার সমূহ।"
  ];

  final List<Color> _colors = [
    Colors.redAccent, // Background color for the first text
    Colors.lightBlueAccent, // Background color for the second text
    Colors.greenAccent
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        if (_carouselIndex < _texts.length - 1) {
          _carouselIndex++;
        } else {
          _carouselIndex = 0; // Reset to the first page
        }
      });
      _pageController.jumpToPage(_carouselIndex); // Change the carousel page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                "https://i.postimg.cc/GhsGhb3K/0050785.jpg",
              ),
            ),
            const SizedBox(width: 10),
            const Text("Towhid Medical"),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {
              print('Phone icon pressed');
            },
            icon: const Icon(
              Icons.phone,
              color: Colors.lightGreenAccent,
            ),
          ),
          IconButton(
            onPressed: () {
              print('Video icon pressed');
            },
            icon: const Icon(
              Icons.video_collection_sharp,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _texts.length,
              onPageChanged: (index) {
                setState(() {
                  _carouselIndex = index; // Update carousel index
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 80, // Fixed height for the colored section
                        color: _colors[index], // Set background color based on index
                        child: Center(
                          child: Text(
                            _texts[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.lightGreenAccent,
        unselectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: const Icon(Icons.countertops), label: "Counter"),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: "Setting"),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Update the bottom navigation index
            _carouselIndex = index; // Update carousel index if needed
            _pageController.jumpToPage(index); // Jump to the selected page
          });
        },
      ),
    );
  }
}
