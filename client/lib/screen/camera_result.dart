import 'dart:convert';
import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/layout/root_tab.dart';
import 'package:client/screen/fail_screen.dart';
import 'package:client/secure_storage/secure_storage.dart';
import '../constant/page_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/default_dialog.dart';
import '../dio/dio.dart';

class CameraResult extends ConsumerWidget {
  final File image;

  CameraResult({
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    final dio = Dio();
    final storage = ref.read(secureStorageProvider);

    void goFailedScreen() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => FailScreen()), (route) => false);
    }

    Future<String> getUserInfoFromStorage() async {
      String user_id = '';

      final temp = await storage.read(key: USER_ID);
      if (temp == null) return '';
      user_id = temp;

      return user_id;
    }

    Future<String> getPresignedUrl(String id) async {
      try {
        String bucket_name = 'user-human-img';
        String image_name = '${id}_human.png';

        dio.options.headers = {'accessToken':'true'};
        dio.interceptors.add(
          CustomInterceptor(storage: storage),
        );

        Response response = await dio.request(
          GET_PRESIGNED_URL,
          data: <String, String>{
            'bucket_name': bucket_name,
            'file_path': image_name
          },
          options: Options(method: 'GET'),
        );
        print(response.data['data']);
        print(response.statusCode);
        return response.data['data'];
      } catch (e) {
        print(e);
        goFailedScreen();
      }
      goFailedScreen();
      return '';
    }

    Future<bool> uploadToPresignedURL(File file, String url) async {
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

    Future<bool> getImageAndUpload(String id) async {
      if (image == null) return false; // 1. image 객체 null 처리

      // 2. presigned url 생성 확인
      String url = await getPresignedUrl(id);

      // 3. S3 upload
      bool isUploaded = await uploadToPresignedURL(image, url);

      return isUploaded;
    }

    Future<bool> requestHumanParsingData(String id) async {
      try {
        final storage = ref.read(secureStorageProvider);
        dio.options.headers = {'accessToken': 'true'};
        dio.interceptors.add(
          CustomInterceptor(storage: storage),
        );
        await dio.post(
          HUMAN_INFER_URL,
          data: json.encode({
            'human_img_path': '${id}_human.png',
            'user_id': id,
          }),
        );
      } on DioError catch (e) {
        print(e.response);
        return false;
      }
      return true;
    }

    void onPictureUpdatePressed() async {
      String id = await getUserInfoFromStorage();
      await getImageAndUpload(id);
      // await requestHumanParsingData(id); todo: 주석 풀기 (완전 테스트용)

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => RootTab()), (route) => false);

      AnimatedSnackBar(
        duration: Duration(seconds: 2),
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        builder: ((context) {
          return Container(
            width: width,
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xDD000000),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Colors.white,),
                SizedBox(width: 16.0,),
                const Text(
                  '사진이 저장되었습니다!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }),
      ).show(context);
    }

    void onReturnPressed() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    return DefaultLayout(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.file(
              image,
              fit: BoxFit.fitWidth,
            ),
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
                        backgroundColor: Color(0xFF2c2c2c),
                      ),
                      onPressed: () async {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return BasicAlertDialog(
                              title: '이 사진으로 저장할까요?',
                              leftButtonText: '다시찍기',
                              rightButtonText:
                                  '사진저장',
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
