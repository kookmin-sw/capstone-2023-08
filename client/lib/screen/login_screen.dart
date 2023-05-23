import 'dart:convert';

import 'package:client/component/one_button_dialog.dart';
import 'package:client/screen/onboarding_screen.dart';
import 'package:dio/dio.dart';
import 'package:client/component/custom_text_form_field.dart';
import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constant/page_url.dart';
import '../layout/root_tab.dart';
import '../secure_storage/secure_storage.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final idTextEditingController = TextEditingController();
  final pwTextEditingController = TextEditingController();

  @override
  void dispose() {
    idTextEditingController.dispose();
    pwTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return DefaultLayout(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            width: width,
            height: height * 0.95,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _TopPart(
                    width: width,
                    height: height,
                  ),
                  const SizedBox(height: 16.0),
                  _MiddleLogin(
                    width: width,
                    idTextEditingController: idTextEditingController,
                    pwTextEditingController: pwTextEditingController,
                    onLoginPressed: onLoginPressed,
                    onIdChanged: onIdChanged,
                    onpwChanged: onPwChanged,
                    onSignUpPressed: onSignUpPressed,
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginPressed() async {
    final dio = Dio();

    String id = idTextEditingController.text;
    String pw = pwTextEditingController.text;
    print('$id, $pw');

    // ID:비밀번호
    final rawString = '$id:$pw';

    Codec<String, String> stringToBase64 = utf8.fuse(base64); // encoding 방식 정의

    String token = stringToBase64.encode(rawString); // 어떤걸 encoding 할지 정의

    Response? resp;
    String? refreshToken;
    String? accessToken;
    bool notLogined = true;
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
      if (resp.statusCode == 200) {
        refreshToken = resp.data['jwt_token']['refresh_token'];
        accessToken = resp.data['jwt_token']['access_token'];
        notLogined = false;
      }
    } catch (e) {
      print(e);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return OneButtonDialog(
              title: '로그인 정보를 확인해주세요',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
    }

    if (notLogined == true) return;
    final storage = ref.read(secureStorageProvider);

    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await storage.write(key: USER_NAME, value: resp!.data['User']['user_name']);
    await storage.write(key: USER_ID, value: resp!.data['User']['user_id']);

    // first 여부 저장
    print('[LOGIN] ${resp.data['User']['user_img_url']}');
    String firstLogin =
        resp.data['User']['user_img_url'] == null ? 'true' : 'false';
    print('[LOGIN] firstLogin? ${firstLogin}');
    await storage.write(key: FIRST_LOGIN, value: firstLogin);
    if (firstLogin == 'true') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OnBoardingPage(),
        ),
        (route) => false,
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => RootTab(),
      ),
      (route) => false,
    );
  }

  void onSignUpPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SignUpScreen()),
    );
  }

  void onIdChanged(value) {
    print(value);
    setState(() {});
  }

  void onPwChanged(value) {
    print(value);
    setState(() {});
  }
}

class _TopPart extends StatelessWidget {
  final double width;
  final double height;

  const _TopPart({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'asset/img/logo.png',
              width: width * 0.4,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            const Text(
              '착붙에 로그인하고\n원하는 옷을 원하는 장소에서 입어보세요!',
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 16.0, //default : 14
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiddleLogin extends StatelessWidget {
  final double width;
  final TextEditingController idTextEditingController;
  final TextEditingController pwTextEditingController;
  final ValueChanged<String>? onIdChanged;
  final ValueChanged<String>? onpwChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  const _MiddleLogin({
    Key? key,
    required this.width,
    required this.idTextEditingController,
    required this.pwTextEditingController,
    required this.onLoginPressed,
    required this.onSignUpPressed,
    this.onIdChanged,
    this.onpwChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // id, pw 둘 중 하나라도 null이면 버튼 비활성화
    bool isLoginButtonValid() {
      return (idTextEditingController.text.isNotEmpty) &&
          (pwTextEditingController.text.isNotEmpty);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextFormField(
          width: width,
          controller: idTextEditingController,
          labelText: '아이디',
          textInputAction: TextInputAction.next,
          onTextChanged: onIdChanged,
        ),
        // 엔터키 누르면 로그인 버튼 눌리는 기능 추가 방법
        // Navigation으로 이동시 textInputAction: TextInputAction.done,
        // onSubmitted : () { // 아이디, 비밀번호 맞는지 확인하고 각각 페이지 보여주는 페이지로 }
        const SizedBox(height: 16.0),
        CustomTextFormField(
          width: width,
          controller: pwTextEditingController,
          labelText: '비밀번호',
          textInputAction: TextInputAction.done,
          onTextChanged: onpwChanged,
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        ValueListenableBuilder<TextEditingValue>(
            valueListenable: idTextEditingController,
            builder: (context, value, child) {
              return SizedBox(
                width: width,
                height: 45.0,
                child: ElevatedButton(
                  onPressed: isLoginButtonValid() ? onLoginPressed : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: PRIMARY_BLACK_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: const Text('로그인'),
                ),
              );
            }),
        const SizedBox(height: 8.0),
        const SizedBox(
          height: 64.0,
          child: Divider(color: BUTTON_BORDER_COLOR),
        ),
        SizedBox(
          width: width,
          height: 45.0,
          child: ElevatedButton(
            onPressed: onSignUpPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF333030)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: Size(80, 25),
              backgroundColor: Colors.white,
              alignment: Alignment.center,
            ),
            child: const Text(
              '회원가입',
              style: TextStyle(
                color: PRIMARY_BLACK_COLOR,
              ),
            ),
          ),
        ),
      ],
    );
  }
<<<<<<< HEAD
}

class _BottomPart extends StatelessWidget {
  final VoidCallback onTextPressed;

  const _BottomPart({
    Key? key,
    required this.onTextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(onPressed: () {}, child: const Text('아이디찾기')),
            TextButton(onPressed: () {}, child: const Text('비밀번호찾기')),
<<<<<<< HEAD
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: const Text('회원가입')),
=======
            TextButton(onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignUpScreen()));
            }, child: const Text('회원가입')),
>>>>>>> upstream/Frontend
          ],
        ),
      ],
=======
    return GestureDetector(
      onTap: onTextPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            '도움이 필요하신가요?',
            style: TextStyle(color: PRIMARY_BLACK_COLOR),
          ),
        ],
      ),
>>>>>>> upstream/Frontend
    );
  }
}
=======
}
>>>>>>> upstream/Frontend
