import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class Pages extends StatelessWidget {
  const Pages({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carousel Slider Demo',
      home: CarouselPage(),
    );
  }
}

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  int _current = 0;
  final imageList = [
  Image.asset('assets/image1.jpg', fit: BoxFit.cover),
  Image.asset('assets/image2.png', fit: BoxFit.cover),
  Image.asset('assets/image3.png', fit: BoxFit.cover),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 400,
              initialPage: 0,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imageList.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: image,
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          DotsIndicator(
            dotsCount: imageList.length,
            position: _current.toDouble(),
            decorator: DotsDecorator(
              activeColor: Colors.black,
              //size: const Size.square(10.0),
              //activeSize: const Size(20.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}