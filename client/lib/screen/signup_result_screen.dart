import 'dart:convert';

import 'package:client/constant/colors.dart';
import 'package:client/data/user_model.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/screen/signup_success.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constant/page_url.dart';
import 'fail_screen.dart';

class SignupResultScreen extends StatelessWidget {
  final UserModel userInfo;

  const SignupResultScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    Future<bool> requestSignUp() async {
      print(userInfo.toJson());
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
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }

    // todo : request Human Parse Data
    Future<void> requestHumanParseData() async {
      try {
        String userId = userInfo.user_id.toString();
        String userImgUrl = userInfo.user_img_url.toString();
        String clothImgUrl = '${userId}_cloth.png';
        print('human infer 요청 전송');
        await dio.post(
          HUMAN_INFER_URL,
          data: json.encode({
            'user_id': userId,
            'human_img_path': userImgUrl,
            'cloth_img_path': clothImgUrl,
          }),
        );
      } catch (e) {
        print(e);
      }
    }

    Future<bool> requestSignupAll() async {
      bool isSignupSuccess = await requestSignUp();
      requestHumanParseData();
      print('requestHumanParseData() 완료, $isSignupSuccess');
      return isSignupSuccess;
    }

    return FutureBuilder(
      future: requestSignupAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return DefaultLayout(
            backgroundColor: PRIMARY_BLACK_COLOR,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        } else {
          if (snapshot.data == true)
            return SignupSuccess();
          else
            return FailScreen();
        }
      },
    );
  }
}
