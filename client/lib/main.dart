import 'package:client/constant/page_name.dart';
import 'package:client/layout/main_layout.dart';
import 'package:client/layout/root_tab.dart';
import 'package:client/screen/clotheslist_screen.dart';
import 'package:client/screen/signup_success.dart';
import 'package:client/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screen/camera_result.dart';
import 'screen/camera_screen.dart';
import 'screen/home_screen.dart';
import 'screen/shoppingmall_screen.dart';
import 'screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: '착붙',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: true,
        initialRoute: SPLASH_SCREEN,
        routes: {
          SPLASH_SCREEN: (context) => SplashScreen(),
          HOME_SCREEN: (context) => RootTab(),
          LOGIN_SCREEN: (context) => LoginScreen(),
          //CAMERA_SCREEN: (context) => CameraScreen(),
          //CAMERA_RESULT: (context) => CameraResult(camera: firstCamera, imagePath: ,),
          SIGNUP_SUCCESS: (context) => SignupSuccess(),
          SHOPPINGMALL_SCREEN: (context) => Pages(),
          // CLOTHESLIST_SCREEN: (context) => ,
      },
      ),
    ),
  );
}
