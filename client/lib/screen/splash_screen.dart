import 'dart:async';

import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';

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
    Timer(Duration(milliseconds: 2000), () {
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultLayout(
      backgroundColor: Colors.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset('asset/img/splash_image1.png', fit: BoxFit.fitWidth,)),
            Positioned.fill(
                child: Container(
              width: width,
              height: height,
              color: Color(0x332C2C2C),
            )),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.1, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        '어디서든',
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0,),
                    SizedBox(
                      child:
                          Text(
                        '입어보는',
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0,),
                    SizedBox(
                      child: Text(
                        '착붙',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 72.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
