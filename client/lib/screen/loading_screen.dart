import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

import '../layout/default_layout.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();

    controller = FlutterGifController(vsync: this);
    controller.repeat(
        min: 0, max: 69, period: const Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return DefaultLayout(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('asset/img/loading.png'),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo_white.png',
                width: width * 0.4,
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Text(
                'AI가 피팅사진을 생성중입니다',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 21.0,
                    color: Colors.white),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                '잠시만 기다려주세요 :)',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 21.0,
                    color: Colors.white),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: 200,
                child: GifImage(
                  width: width * 0.4,
                  controller: controller,
                  image: AssetImage('asset/img/loading_color.gif'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
