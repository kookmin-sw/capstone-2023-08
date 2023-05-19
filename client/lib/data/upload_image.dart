import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constant/page_url.dart';
import '../dio/dio.dart';
import '../screen/fail_screen.dart';

import 'package:http/http.dart' as http;

class UploadImage {
  final Dio dio;
  final FlutterSecureStorage storage;
  final BuildContext context;
  final File image;

  UploadImage({
    required this.dio,
    required this.storage,
    required this.image,
    required this.context,
  });

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

      dio.options.headers = {'accessToken': 'true'};
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );

      Response response = await dio.request(
        GET_PRESIGNED_URL,
        data: <String, String>{
          'bucket_name': bucket_name,
          'file_path': image_name
        },
        options: Options(
          method: 'GET',
          followRedirects: false,
        ),
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

  Future<bool> uploadToS3Http(File file, String url) async {
    try {
      var s3Response = await http.put(
        // dio 패키지 사용 X
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/octet-stream',
        },
        body: await file.readAsBytes(),
      );
      if (s3Response.statusCode == 200) return true;
      goFailedScreen();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getImageAndUpload(String id) async {
    // 1. presigned url 생성 확인
    String url = await getPresignedUrl(id);

    // 2. S3 upload
    bool isUploaded = await uploadToS3Http(image, url);
    print('s3 upload success? : ${isUploaded}');

    return isUploaded;
  }

  Future<bool> requestHumanParsingData() async {
    String id = await getUserInfoFromStorage();
    try {
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
}