import 'dart:async';

import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../layout/root_tab.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    moveToRoot();
  }

  void moveToRoot() {
    Timer(Duration(milliseconds: 3000), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.0,
                child: AnimatedTextKit(
                  repeatForever: true,
                    animatedTexts: [
                  RotateAnimatedText(
                    '어디서든',
                    alignment: Alignment.centerLeft,
                    textStyle: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 8.0,),
              SizedBox(
                height: 60.0,
                child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                  RotateAnimatedText(
                    '입어보는',
                    alignment: Alignment.centerLeft,
                    textStyle: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 8.0,),
              Image.asset(
                'asset/img/logo.png',
                width: MediaQuery.of(context).size.width * 0.75,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
