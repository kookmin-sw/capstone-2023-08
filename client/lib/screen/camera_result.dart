import 'dart:io';
import 'dart:typed_data';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:client/component/custom_snackbar.dart';
import 'package:client/component/loading_screen.dart';
import 'package:client/data/upload_image.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/layout/root_tab.dart';
import 'package:client/secure_storage/secure_storage.dart';
import '../constant/page_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../component/default_dialog.dart';
import '../dio/dio.dart';

class CameraResult extends ConsumerStatefulWidget {
  final File image;
  bool? isBack;

  CameraResult({
    required this.image,
    this.isBack = false,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CameraResult> createState() => _CameraResultState();
}

class _CameraResultState extends ConsumerState<CameraResult> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    final dio = Dio();
    final storage = ref.read(secureStorageProvider);

    final upload = UploadImage(
        dio: dio, storage: storage, context: context, image: widget.image);

    Future<bool> onPictureUpdatePressed() async {
      String id = await upload.getUserInfoFromStorage();
      await upload.getImageAndUpload(id);
      upload.requestHumanParsingData(id);

      final firstLogin = await storage.read(key: FIRST_LOGIN);

      // first_login -> 사진 저장한 경우
      // 1. user_img_url update
      // 2. first login = false로 변경
      if (firstLogin == 'true') {
        dio.options.headers = {'accessToken': 'true'};
        dio.interceptors.add(
          CustomInterceptor(storage: storage),
        );

        Response response;
        try {
          response = await dio.post(UPDATE_IMG_URL, data: {
            'user_img_url': 's3://user-human-img/${id}_human.png',
          });
          if (response.statusCode == 200) {
            await storage.write(key: FIRST_LOGIN, value: 'false');
            print('first login and saved to s3');
          }
        } catch (e) {
          print(e);
        }
      }

      // Root로 이동
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RootTab()), (route) => false);

      // ignore: use_build_context_synchronously
      final snackBar = CustomSnackBar(text: '사진이 저장되었습니다!', context: context);
      snackBar.renderSnackBar();

      return true;
    }

    void onReturnPressed() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    return DefaultLayout(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.file(
              widget.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2c2c2c),
                      ),
                      onPressed: () async {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return BasicAlertDialog(
                              title: '이 사진으로 저장할까요?',
                              leftButtonText: '돌아가기',
                              rightButtonText: '사진저장',
                              onLeftButtonPressed: onReturnPressed,
                              onRightButtonPressed: onPictureUpdatePressed,
                            );
                          },
                        );
                      },
                      child: const Text('다음'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
