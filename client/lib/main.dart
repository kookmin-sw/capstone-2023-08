import 'package:client/constant/page_name.dart';
import 'package:client/layout/main_layout.dart';
import 'package:client/screen/clotheslist_screen.dart';
import 'package:client/screen/signup_success.dart';
import 'package:flutter/material.dart';
import 'screen/camera_result.dart';
import 'screen/camera_screen.dart';
import 'screen/home_screen.dart';
import 'screen/shoppingmall_screen.dart';
import 'package:camera/camera.dart';
import 'screen/login_screen.dart';

Future<void> main() async {
  // 카메라 초기화 및 가능한 카메라 목록 -> 첫번째 카메라 가져오기
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      title: 'Fit on, Fit me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: true,
      initialRoute: HOME_SCREEN,
      routes: {
        HOME_SCREEN: (context) => MainLayout(),
        LOGIN_SCREEN: (context) => LoginScreen(),
        CAMERA_SCREEN: (context) => CameraScreen(camera: firstCamera,),
        // CAMERA_RESULT: (context) => CameraResult(camera: firstCamera, imagePath: ,),
        SIGNUP_SUCCESS: (context) => SignupSuccess(),
        SHOPPINGMALL_SCREEN: (context) => Pages(),
        // CLOTHESLIST_SCREEN: (context) => ,
    },
    ),
  );
}
