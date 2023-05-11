import 'dart:async';
import 'dart:convert';

import 'package:client/layout/default_layout.dart';
import 'package:client/screen/my_page_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant/page_url.dart';
import '../layout/root_tab.dart';
import 'package:client/secure_storage/secure_storage.dart';

import 'login_screen.dart';

// StatefulScreen인 경우, 3번까지의 절차 필요
// setState 사용 가능 (riverpod으로 관리하는 건 global 변수, setState는 loacal 변수라고 생각하면 됩니다!)
class SplashScreen extends ConsumerStatefulWidget { // 1. ConsumerStatefulWidget으로 변경
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState(); // 2. State -> ConsumerState로 변경
}

class _SplashScreenState extends ConsumerState<SplashScreen> { // 3. 이 부분도 ConsumerState로 변경
  @override
  void initState() {
    super.initState();

    checkToken();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);

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
        data: json.encode({"refresh" : refreshToken,}),
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
