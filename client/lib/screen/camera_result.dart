import 'dart:convert';
import 'dart:io';

import 'package:client/screen/signup_success.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../component/default_dialog.dart';
import '../constant/page_url.dart';
import '../data/account.dart';

class CameraResult extends StatelessWidget {
  final Account userInfo;
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

    Future<String> getPresignedUrl() async {
      try {
        String userId = userInfo.id.toString();
        String url = GET_PRESIGNED_URL;
        Response response = await dio.request(
          url,
          data: <String, String>{'user_id': userId},
          options: Options(method: 'GET'),
        );
        print(response.data['data']);
        print(response.statusCode);
        return response.data['data'];
      } catch (e) {
        print(e);
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
            contentType: "image/jpeg",
            headers: {
              "Content-Length": file.lengthSync(),
            },
          ),
        );
        if (response.statusCode == 200) return true;
        return false;
      } on DioError catch (e) {
        print(e.response);
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

    Future<bool> requestSignUp() async {
      Response response;
      try {
        response = await dio.post(
          SIGN_UP_URL,
          data: json.encode(userInfo.toJson()),
        );
        print(response.data);
        if (response.statusCode == 200) {
          response = await dio.get(SIGN_UP_URL);
          print(response.data);
        } else {
          // todo: 실패 처리
        }
      } catch (e) {

      }
      return true;
    }

    void onReturnPressed() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }

    void onSignupPressed() async {
      await getImageAndUpload();
      await requestSignUp();

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SignupSuccess()),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: SizedBox(
            width: width,
            height: height,
            child: Image.file(File(image.path)),
          ),
        ),
        Positioned(
          bottom: 24,
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
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
    );
  }
}
