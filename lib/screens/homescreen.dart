import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_advanced/models/models.dart';
import 'package:flutter_app_advanced/screens/details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  "Find Your Style",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 30),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 0.78,
              child: PageView.builder(
                itemCount: dataList.length,
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return carouselView(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.038).clamp(-1, 1);
        }
        return Transform.rotate(
          angle: pi * value,
          child: carouselCard(dataList[index]),
        );
      },
    );
  }

  Widget carouselCard(DataModel data) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: data.imageName,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(data: data)));
                },
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage(
                        data.imageName,
                      ),
                      fit: BoxFit.fill),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black26)
                  ],
                )),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            data.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black45),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "\$${data.price}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
