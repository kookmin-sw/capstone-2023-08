import 'dart:convert';
import 'dart:io';

import 'package:client/layout/default_layout.dart';
import 'package:client/screen/fail_screen.dart';
import 'package:client/screen/signup_result_screen.dart';
import 'package:client/screen/signup_success.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../component/default_dialog.dart';
import '../constant/colors.dart';
import '../constant/page_url.dart';
import '../data/account_model.dart';

class CameraResult extends StatelessWidget {
  final AccountModel userInfo;
  final XFile image;

  const CameraResult({
    required this.userInfo,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    final dio = Dio();

    void goFailedScreen () {
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => FailScreen()),
              (route) => false);
    }

    Future<String> getPresignedUrl() async {
      try {
        String userImgUrl = userInfo.user_img_url.toString();
        String url = GET_PRESIGNED_URL;
        Response response = await dio.request(
          url,
          data: <String, String>{
            'bucket_name': 'user-human-img',
            'file_path': userImgUrl},
          options: Options(method: 'GET'),
        );
        print(response.data['data']);
        print(response.statusCode);
        return response.data['data'];
      } catch (e) {
        print(e);
        goFailedScreen();
      }
      return '';
    }

    Future<bool> uploadToSignedURL(
        {required File file, required String url}) async {
      Response response;
      try {
        response = await dio.put(
          url,
          data: file.openRead(),
          options: Options(
            contentType: "image/png",
            headers: {
              "Content-Length": file.lengthSync(),
            },
          ),
        );
        if (response.statusCode == 200) return true;
        goFailedScreen();
        return false;
      } on DioError catch (e) {
        print(e.response);
        goFailedScreen();
        return false;
      }
    }

    Future<void> getImageAndUpload() async {
      if (image == null) return; // 1. image 객체 null 처리

      // 2. presigned url 생성 확인
      String url = await getPresignedUrl();

      // 3. S3 upload
      bool isUploaded = await uploadToSignedURL(file: File(image.path), url: url);
      print(isUploaded);
    }

    void onSignupPressed() async {
      await getImageAndUpload();

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SignupResultScreen(userInfo: userInfo)),
      );
    }

    void onReturnPressed() {
      Navigator.of(context).pop();
    }

    return DefaultLayout(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.file(File(image.path), fit: BoxFit.fitWidth,),
          ),
          Container(
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
                        backgroundColor: PRIMARY_BLACK_COLOR,
                      ),
                      onPressed: () async {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return BasicAlertDialog(
                              title: '이 사진으로 가입할까요?',
                              leftButtonText: '다시찍기',
                              rightButtonText: '회원가입',
                              onLeftButtonPressed: onReturnPressed,
                              onRightButtonPressed: onSignupPressed,
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
