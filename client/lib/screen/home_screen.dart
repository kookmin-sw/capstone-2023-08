import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/screen/result_all_screen.dart';
import 'package:flutter/material.dart';

import 'clotheslist_screen.dart';
import 'gallery_pick_screen.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 174, 53)
      // ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    double dx = 0;
    double dy = 0;

    final path = Path()
      ..moveTo(dx, dy)
      ..lineTo(dx - size.width, dy + size.height)
      ..lineTo(dx, dy + size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var finalWidth = 390;
    var finalHeight = 844;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 80 * (screenHeight / finalHeight),
            left: 30 * (screenWidth / finalWidth),
            child: Image.asset(
              'asset/logo_white.png',
              width: 128,
              height: 61,
            ),
          ),
          Positioned(
            top: 180 * (screenHeight / finalHeight),
            left: 30 * (screenWidth / finalWidth),
            child: Container(
                alignment: const Alignment(0, -0.4),
                child: const Text(
                  "원하는 옷을\n원하는 장소에서 입어보세요!",
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.3,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Pretendard-Bold"),
                )),
          ),
          Positioned(
            top: 15 * (screenHeight / finalHeight),
            right: -78 * (screenWidth / finalWidth),
            child: CustomPaint(
              size: const Size(75, 240), // 위젯의 크기를 정함.
              painter: MyPainter(), // painter에 그리기를 담당할 클래스를 넣음.
            ),
          ),
          Positioned(
            top: 250 * (screenHeight / finalHeight),
            //left: -10 * (screenWidth / finalWidth),
            child: Image.asset(
              'asset/image.png',
              //width: 410 * (screenWidth / finalWidth),
              height: 400,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            left: 30,
            bottom: screenHeight * 0.15,
            child: const Text(
              "무신사 옷을 입어보거나\n직접 옷을 선택해서 입어볼 수 있어요!",
              style: TextStyle(
                  color: INPUT_BORDER_COLOR,
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Pretendard-Bold"),
            ),
          ),
          Positioned(
              top: 650 * (screenHeight / finalHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: const Alignment(-0.5, 0.7),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShoppingApp()));
                      }, // 옷 리스트 페이지(closelist) 이동
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 100),
                        primary: Colors.black, // Background color
                        alignment: Alignment.center,
                      ),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'MUSINSA\n',
                                ),
                                TextSpan(
                                  text: '옷 입어보기',
                                ),
                              ],
                              style: TextStyle(
                                  fontFamily: "Pretendard", fontSize: 17))),
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 40,
                    color: Colors.white,
                  ),
                  Container(
                    //alignment: Alignment(0.5, 0.7),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GalleryPickScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 100),
                        primary: Colors.black, // Background color
                      ),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '갤러리에서\n',
                                ),
                                TextSpan(
                                  text: '옷 입어보기',
                                ),
                              ],
                              style: TextStyle(
                                  fontFamily: "Pretendard", fontSize: 17))),
                    ),
                  )
                ],
              )),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
