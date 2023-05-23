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
      backgroundColor: Colors.black,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('asset/img/loading.png'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
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
              const Text(
                'AI가 피팅사진을 생성중입니다',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 21.0,
                    color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '잠시만 기다려주세요 :)',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 21.0,
                    color: Colors.white),
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                height: 150,
                child: GifImage(
                  width: width * 0.2,
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
