import 'dart:convert';

import 'package:client/component/async_button.dart';
import 'package:client/constant/colors.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/screen/onboarding_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/custom_text_form_field.dart';
import '../data/user_model.dart';
import '../layout/default_layout.dart';
import '../secure_storage/secure_storage.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final Dio dio = Dio();
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
          return true;
        } else {
          print(response.data);
          print(response.statusCode);
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<void> requestSignin () async {
      final String? id = userInfo.user_id;
      final String? pw = userInfo.password;

      final rawString = '${id}:${pw}';
      print(rawString);

      Codec<String, String> stringToBase64 = utf8.fuse(base64); // encoding 방식 정의

      String token = stringToBase64.encode(rawString); // 어떤걸 encoding 할지 정의

      final Dio dio = Dio();

      Response resp;
      String refreshToken;
      String accessToken;
      try {
        resp = await dio.post(
          SIGN_IN_URL,
          options: Options(
            headers: {
              'Authorization': 'Basic $token',
            },
          ),
          data: json.encode({
            'user_id': id,
            'password': pw,
          }),
        );

        refreshToken = resp.data['jwt_token']['refresh_token'];
        accessToken = resp.data['jwt_token']['access_token'];

        final storage = ref.read(secureStorageProvider);

        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        await storage.write(key: USER_NAME, value: resp.data['User']['user_name']);
        await storage.write(key: USER_ID, value: resp.data['User']['user_id']);
        await storage.write(key: FIRST_LOGIN, value: 'true');

        print('로그인 완료');
      } catch (e) {
        print(e);
      }
    }

    return DefaultLayout(
      title: '회원가입',
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: width,
            height: height * 0.9,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextFormField(
                      width: width,
                      key: const ValueKey(1),
                      controller: _idController,
                      labelText: '아이디',
                      onTextChanged: onIdChanged,
                      validator: (val) {return idText;},
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: const ValueKey(2),
                      width: width,
                      controller: _passwordController,
                      labelText: '비밀번호',
                      obscureText: true,
                      onTextChanged: onpwChanged,
                      validator: pwValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    CustomTextFormField(
                      width: width,
                      controller: _confirmPasswordController,
                      labelText: '비밀번호 확인',
                      obscureText: true,
                      validator: pwConfirmValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: const ValueKey(3),
                      width: width,
                      controller: _nicknameController,
                      labelText: '닉네임',
                      onTextChanged: nameChanged,
                      validator: (val) {return nameText;},
                    ),
                    const SizedBox(height: 32.0),
                    AsyncButton(
                      height: 45.0,
                      text: '회원가입하기',
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            isIdValidate && isNameValidate) {
                          await requestSignUp();
                          await requestSignin();

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const OnBoardingPage()));
                        }
                      },
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