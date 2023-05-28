import 'dart:async';
import 'dart:convert';

import 'package:client/layout/default_layout.dart';
import 'package:client/screen/onboarding_screen.dart';
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
    final userId = await storage.read(key: USER_ID);
    final userName = await storage.read(key: USER_NAME);

    if (firstLogin == 'true') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const OnBoardingPage(),
        ),
        (route) => false,
      );
      return;
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
                        delay: delayAmount,
                        offset_dx: -0.35,
                        offset_dy: 0.0,
                        child: const Text(
                          '어디서든',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset(
                        'asset/img/long_line.png',
                        width: width * 0.15,
                      ),
                      const SizedBox(width: 32),
                      ShowUp(
                        delay: delayAmount,
                        offset_dx: -0.35,
                        offset_dy: 0.0,
                        child: const Text(
                          '입어보는',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
  // ignore: non_constant_identifier_names
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
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(
            begin: Offset(widget.offset_dx, widget.offset_dy), end: Offset.zero)
        .animate(curve);

    // ignore: unnecessary_null_comparison
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
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}