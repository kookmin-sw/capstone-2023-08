import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:client/constant/colors.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/screen/camera_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../component/custom_text_form_field.dart';
import '../data/user_model.dart';
import '../layout/default_layout.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode myFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  UserModel userInfo = UserModel();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool isIdValidate = false;
  String? idText;
  bool isNameValidate = false;
  String? nameText;

  @override
  void dispose() {
    myFocusNode.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    bool textNullCheck(value, String category) {
      if (value == null || value.isEmpty) {
        setState(() {
          switch (category) {
            case '아이디' : idText = '$category를 입력해주세요'; break;
            case '닉네임' : nameText = '$category를 입력해주세요'; break;
          }
        });
        return true;
      }
      return false;
    }

    Future<void> isIdDuplicated() async {
      final dio = Dio();
      final value = _idController.text;

      if (textNullCheck(value, '아이디') == true) return;

      Response response;
      try {
        response = await dio.get(
          SIGN_UP_ID_CHECK_URL,
          data: json.encode(
              {'user_id': value.toString()}),
        );

        if (response.statusCode == 205) {
          setState(() {
            idText = '중복되는 아이디가 있습니다. 다른 아이디로 시도해주세요';
          });
        } else {
          setState(() {
            isIdValidate = true;
            idText = null;
          });
          print('아이디 중복 x');
        }
      } catch (e) {
        print(e);
      }
    }

    Future<void> idValidator() async {
      final value = _idController.text;
      if (textNullCheck(value, '아이디') == true) return;

      // validate string이 아니면 제외.
      final validStr = RegExp(r'[A-Za-z0-9]$');
      if (!validStr.hasMatch(value)) {
        setState(() {
          idText = '아이디는 알파벳, 숫자만 사용해주세요';
          print(idText);
        });
        return;
      }

      await isIdDuplicated();
    }

    void onIdChanged(value) async {
      userInfo.user_id = value;
      userInfo.user_img_url = value + "_human.png";

      // 모든 validation check 수행 = isIdValidate, 그거 초기화
      setState(() {
        isIdValidate = false;
      });

      await idValidator();
    }

    void onpwChanged(value) {
      userInfo.password = value;
    }

    String? pwValidator(value) {
      if (value == null || value.isEmpty) {
        return '비밀번호를 입력해주세요';
      }
      if (value.length < 6) {
        return '비밀번호는 최소 6자 이상 입력해야 합니다';
      }

      // validate string이 아니면 제외.
      final validStr = RegExp(r'[A-Za-z0-9!@#$%^_]$');
      print('[pw] $value is valid? ${validStr.hasMatch(value)}');
      if (!validStr.hasMatch(value)) {
        return '알파벳, 숫자, 특수문자(!@#\$%^_)만 사용할 수 있습니다';
      }
      return null;
    }

    String? pwConfirmValidator(value) {
      if (value == null || value.isEmpty) {
        return '비밀번호 확인 문자를 입력해주세요';
      }
      if (value != _passwordController.text) {
        return '비밀번호가 입력한 문자와 일치하지 않습니다';
      }
      return null;
    }

    Future<void> isNameDuplicated() async {
      final dio = Dio();
      final value = _nicknameController.text;

      if (textNullCheck(value, '닉네임') == true) return;

      Response response;
      try {
        response = await dio.get(
          SIGN_UP_NAME_CHECK_URL,
          data: json.encode(
              {'user_name': value.toString()}),
        );

        if (response.statusCode == 205) {
          setState(() {
            nameText = '중복되는 닉네임이 있습니다. 다른 닉네임으로 시도해주세요';
          });
        } else {
          setState(() {
            isNameValidate = true;
            nameText = null;
          });
          print('닉네임 중복 x');
        }
      } catch (e) {
        print(e);
      }
    }

    Future<void> nameValidator() async {
      final value = _nicknameController.text;
      if (textNullCheck(value, '닉네임') == true) return;

      if (value.length > 10) {
        setState(() {
          nameText = '닉네임은 10자 이하로 입력해주세요';
        });
        return;
      }

      await isNameDuplicated();
    }

    void nameChanged(value) async {
      userInfo.user_name = value;

      setState(() {
        isNameValidate = false;
      });

      await nameValidator();
    }

    bool isValid() {
      return (_idController.text.length > 0) &&
          (_passwordController.text.length > 0) &&
          (_confirmPasswordController.text.length > 0) &&
          (_nicknameController.text.length > 0) &&
          isIdValidate && isNameValidate;
    }

    return DefaultLayout(
      title: '회원가입',
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: width,
            height: height * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextFormField(
                      width: width,
                      key: ValueKey(1),
                      focusNode: myFocusNode,
                      controller: _idController,
                      labelText: '아이디',
                      onTextChanged: onIdChanged,
                      validator: (val) {return idText;},
                      textInputAction: TextInputAction.next,
                      isFocused: myFocusNode.hasFocus,
                    ),
                    SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: ValueKey(2),
                      width: width,
                      controller: _passwordController,
                      labelText: '비밀번호',
                      obscureText: true,
                      onTextChanged: onpwChanged,
                      validator: pwValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 24.0),
                    CustomTextFormField(
                      width: width,
                      controller: _confirmPasswordController,
                      labelText: '비밀번호 확인',
                      obscureText: true,
                      validator: pwConfirmValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: ValueKey(3),
                      width: width,
                      controller: _nicknameController,
                      labelText: '닉네임',
                      onTextChanged: nameChanged,
                      validator: (val) {return nameText;},
                    ),
                    SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 45.0,
                      child: ElevatedButton(
                        onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    isIdValidate && isNameValidate) {
                                  print('camera start');
                                  List<CameraDescription> cameras =
                                      await availableCameras();

                                  print('available camera ${cameras.isEmpty}');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => CameraScreen(
                                          cameras: cameras,
                                          userInfo: userInfo)));
                                }
                              },
                        child: Text('촬영하고 회원가입하기'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          minimumSize: Size(80, 25),
                          backgroundColor: PRIMARY_BLACK_COLOR,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}