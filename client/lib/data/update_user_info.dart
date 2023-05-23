import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../component/custom_snackbar.dart';
import '../component/one_button_dialog.dart';
import '../constant/page_url.dart';
import '../dio/dio.dart';
import '../screen/my_page_screen.dart';

class UpdateUserInfo {
  final BuildContext context;
  final Dio dio;
  final FlutterSecureStorage storage;

  UpdateUserInfo({
    required this.context,
    required this.dio,
    required this.storage,
  });

  Future<void> updateSomething(
      {required String url,
      required Map<String, String> data,
      required bool isName}) async {
    dio.options.headers = {'accessToken': 'true'};
    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );
    Response response;
    try {
      response = await dio.post(
        url,
        data: json.encode(data),
      );
      if (response.statusCode == 205) {
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return OneButtonDialog(
              title: response.data['message'],
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
      if (response.statusCode == 200) {
        String message = response.data['message'];

        if (isName) {
          final new_name = response.data['User']['user_name'];
          await storage.write(key: USER_NAME, value: new_name);
        } else {
          final accessToken = response.data['jwt_token']['access_token'];
          final refreshToken = response.data['jwt_token']['refresh_token'];

          await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
          await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
        }

        // 상위탭으로 이동
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MyPageScreen()),
            (route) => false);

        // snackbar 보여주기
        // ignore: use_build_context_synchronously
        final snackbar = CustomSnackBar(text: message, context: context);
        snackbar.renderSnackBar();
      }
    } catch (e) {
      print(e);
    }
  }
}
