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
import 'package:webview_flutter/webview_flutter.dart';

import '../component/default_dialog.dart';
import '../constant/page_url.dart';
import 'app_homepage_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    List<Widget> _loginLayout = <Widget>[
      ProfileScreen(
        width: width,
        height: height,
      ),
      AppInfoScreen(),
      LogoutButton(),
    ];

    return DefaultLayout(
      child: ListView.separated(
        itemCount: _loginLayout.length,
        itemBuilder: (_, index) {
          return _loginLayout[index];
        },
        separatorBuilder: (BuildContext context, int index) => index != 0
            ? Divider(color: BUTTON_BORDER_COLOR, height: 24.0,)
            : SizedBox(height: 16.0),
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
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'asset/img/logo_white.png',
                    width: width * 0.3,
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '안녕하세요!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
                  SizedBox(height: 16.0,)
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
              child: Divider(color: Colors.white),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.white,),
              title: Text(
                '내 정보 수정하기',
                style: TextStyle(color: Colors.white),
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
            SizedBox(
              height: 10.0,
              child: Divider(color: Colors.white),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.white,),
              title: Text(
                '내 사진 수정하기',
                style: TextStyle(color: Colors.white),
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

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Text(
              '어플정보',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TestScreen()));
            },
            title: Text('공지사항'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AppHomePageScreen()));
            },
            title: Text('어플소개'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: ListTile(
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
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
