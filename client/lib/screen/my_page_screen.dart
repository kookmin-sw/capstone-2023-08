import 'package:camera/camera.dart';
import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/screen/camera_screen.dart';
import 'package:client/screen/splash_screen.dart';
import 'package:client/screen/test_screen.dart';
import 'package:client/screen/user_info_update_screen.dart';
import 'package:client/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/default_dialog.dart';
import '../constant/page_url.dart';
import 'app_homepage_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileScreen(
            width: width,
            height: height,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                  child: Text(
                    '어플정보',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C7C7C)),
                  ),
                ),
                Divider(
                  color: Color(0xFFF2F2F2),
                  height: 24.0,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => AppHomePageScreen()));
                  },
                  title: Text('어플소개'),
                  trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFFC6C6C6),),
                ),
                Divider(
                  color: Color(0xFFF2F2F2),
                  height: 10.0,
                ),
                LogoutButton(),
                Divider(
                  color: Color(0xFFF2F2F2),
                  height: 16.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  final double width;
  final double height;

  const ProfileScreen({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<String?> getUserName() async {
      final storage = ref.watch(secureStorageProvider);
      final user_name = await storage.read(key: USER_NAME);
      print(user_name);
      return user_name;
    }

    return Container(
      color: PRIMARY_BLACK_COLOR,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 16.0, left: 8.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'asset/img/logo_white.png',
                        width: width * 0.25,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.1),
                  Text(
                    '안녕하세요!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  FutureBuilder(
                    future: getUserName(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == true) {
                        return Text(
                          '${snapshot.data}님.',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(
                '내 정보 수정하기',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              onTap: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UserInfoUpdateScreen()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                  height: 16.0, child: Divider(color: Color(0xFF474747))),
            ),
            ListTile(
              title: Text(
                '내 사진 수정하기',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              onTap: () async {
                List<CameraDescription> cameras = await availableCameras();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CameraScreen(cameras: cameras)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return BasicAlertDialog(
                title: '정말 로그아웃할까요?',
                onLeftButtonPressed: () {
                  Navigator.of(context).pop();
                },
                onRightButtonPressed: () {
                  final storage = ref.watch(secureStorageProvider);
                  storage.deleteAll();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => SplashScreen()),
                    (route) => false,
                  );
                },
                leftButtonText: '아니요',
                rightButtonText: '네',
              );
            });
      },
      title: Text('로그아웃'),
      trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFFC6C6C6),),
    );
  }
}
