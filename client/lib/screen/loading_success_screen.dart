import 'dart:async';
import 'dart:io';

import 'package:client/screen/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

import '../layout/default_layout.dart';

class LoadingSuccessScreen extends StatefulWidget {
  final File imageFile;

  const LoadingSuccessScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<LoadingSuccessScreen> createState() => _LoadingSuccessScreenState();
}

class _LoadingSuccessScreenState extends State<LoadingSuccessScreen>
    with SingleTickerProviderStateMixin {
  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();

    controller = FlutterGifController(vsync: this);
    controller.repeat(
        min: 0, max: 130, period: const Duration(milliseconds: 1500));

    Timer(const Duration(milliseconds: 1500), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ResultScreen(
          imageFile: widget.imageFile,
        ),
      ));
    });
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
                '피팅 사진 생성 완료!',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 21.0,
                    color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                height: 100,
                child: GifImage(
                  width: width * 0.2,
                  controller: controller,
                  image: AssetImage('asset/img/check.gif'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
