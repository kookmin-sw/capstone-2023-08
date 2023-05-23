import 'dart:async';

import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class FailScreen extends StatefulWidget {
  const FailScreen({Key? key}) : super(key: key);

  @override
  State<FailScreen> createState() => _FailScreenState();
}

class _FailScreenState extends State<FailScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SplashScreen()),
        (route) => false,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_BLACK_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '😥',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '요청하신 작업을 수행할 수 없습니다',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '죄송하지만,',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              '다시 한번 더 시도해주세요',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
