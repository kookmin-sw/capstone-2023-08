import 'dart:async';
import 'dart:convert';

import 'package:client/layout/default_layout.dart';
import 'package:client/screen/my_page_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant/page_url.dart';
import '../layout/root_tab.dart';
import 'package:client/secure_storage/secure_storage.dart';

import 'login_screen.dart';

// StatefulScreen인 경우, 3번까지의 절차 필요
// setState 사용 가능 (riverpod으로 관리하는 건 global 변수, setState는 loacal 변수라고 생각하면 됩니다!)
class SplashScreen extends ConsumerStatefulWidget {
  // 1. ConsumerStatefulWidget으로 변경
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() =>
      _SplashScreenState(); // 2. State -> ConsumerState로 변경
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // 3. 이 부분도 ConsumerState로 변경
  @override
  void initState() {
    super.initState();

    checkToken();
    FlutterNativeSplash.remove();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);

    final firstLogin = await storage.read(key: FIRST_LOGIN);
    if (firstLogin == 'true') { // todo : 백엔드 설정에 따라 바꾸기
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );
    }

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    print('refreshToken accessToken');
    print('$refreshToken $accessToken');

    final dio = Dio();

    try {
      final resp = await dio.post(
        GET_ACCESS_TOKEN_URL,
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
        data: json.encode({
          "refresh": refreshToken,
        }),
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['access']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  bool animate = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int delayAmount = 400;

    return DefaultLayout(
      backgroundColor: Colors.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              'asset/img/splash.png',
              fit: BoxFit.cover,
            )),
            Positioned(
              top: height * 0.55,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'asset/img/short_line.png',
                        width: width * 0.05,
                      ),
                      SizedBox(width: 32),
                      ShowUp(
                          child: Text(
                            '어디서든',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          delay: delayAmount,
                          offset_dx: -0.35,
                          offset_dy: 0.0),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'asset/img/long_line.png',
                        width: width * 0.15,
                      ),
                      SizedBox(width: 32),
                      ShowUp(
                          child: Text('입어보는',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              )),
                          delay: delayAmount,
                          offset_dx: -0.35,
                          offset_dy: 0.0),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                top: height * 0.05,
                left: width * 0.1,
                child: Image.asset(
                  'asset/img/logo.png',
                  width: width * 0.5,
                )),
          ],
        ),
      ),
    );
  }
}

class ShowUp extends StatefulWidget {
  final Widget child;
  final int delay;
  final double offset_dx;
  final double offset_dy;

  ShowUp(
      {required this.child,
      required this.delay,
      required this.offset_dx,
      required this.offset_dy});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(
            begin: Offset(widget.offset_dx, widget.offset_dy), end: Offset.zero)
        .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}
