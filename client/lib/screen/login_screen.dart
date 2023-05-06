import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:client/component/custom_text_form_field.dart';
import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constant/page_url.dart';
import '../layout/root_tab.dart';
import '../secure_storage/secure_storage.dart';
import 'find_account_screen.dart';
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
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: width,
            height: height * 0.8,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
              child: DefaultLayout(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _TopPart(
                      width: width,
                    ),
                    SizedBox(height: 16.0),
                    _MiddleLogin(
                      width: width,
                      idTextEditingController: idTextEditingController,
                      pwTextEditingController: pwTextEditingController,
                      onLoginPressed: onLoginPressed,
                      onIdChanged: onIdChanged,
                      onpwChanged: onPwChanged,
                      onSignUpPressed: onSignUpPressed,
                    ),
                    SizedBox(height: 24.0),
                    _BottomPart(
                      onTextPressed: onTextPressed,
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

  void onLoginPressed() async {
    final dio = Dio();

    String id = idTextEditingController.text;
    String pw = pwTextEditingController.text;
    print('$id, $pw');

    // ID:비밀번호
    final rawString = '$id:$pw';

    Codec<String, String> stringToBase64 = utf8.fuse(base64); // encoding 방식 정의

    String token = stringToBase64.encode(rawString); // 어떤걸 encoding 할지 정의

    Response resp;
    String refreshToken;
    String accessToken;
    try {
      resp = await dio.get(
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
      print(resp.data['jwt_token']['refresh_token']);
      print(resp.data['jwt_token']['access_token']);

      refreshToken = resp.data['jwt_token']['refresh_token'];
      accessToken = resp.data['jwt_token']['access_token'];
    } catch (e) {
      print(e);
      return;
    }

    final storage = ref.read(secureStorageProvider);

    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

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

  void onTextPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FindAccountScreen()),
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

  const _TopPart({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '착붙에 오신 것을 환영합니다',
            style: TextStyle(
              color: PRIMARY_BLACK_COLOR,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            '착붙에서 가상피팅을 체험해보세요',
            style: TextStyle(
              color: PRIMARY_BLACK_COLOR,
              fontSize: 16.0, //default : 14
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
      return (idTextEditingController.text.length > 0) &&
          (pwTextEditingController.text.length > 0);
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
        SizedBox(
          height: 16.0,
        ),
        CustomTextFormField(
          width: width,
          controller: pwTextEditingController,
          labelText: '비밀번호',
          textInputAction: TextInputAction.done,
          onTextChanged: onpwChanged,
          obscureText: true,
        ),
        SizedBox(
          height: 16.0,
        ),
        ValueListenableBuilder<TextEditingValue>(
            valueListenable: idTextEditingController,
            builder: (context, value, child) {
              return SizedBox(
                width: width,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: isLoginButtonValid() ? onLoginPressed : null,
                  child: const Text(
                    '로그인',
                    style: TextStyle(),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: PRIMARY_BLACK_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                  ),
                ),
              );
            }),
        SizedBox(
          height: 8.0,
        ),
        SizedBox(
          height: 32.0,
          child: Divider(color: BUTTON_BORDER_COLOR),
        ),
        SizedBox(
          width: width,
          height: 40.0,
          child: ElevatedButton(
            onPressed: onSignUpPressed,
            child: const Text(
              '회원가입',
              style: TextStyle(
                color: PRIMARY_BLACK_COLOR,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: Size(80, 25),
              backgroundColor: Colors.white,
              alignment: Alignment.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomPart extends StatelessWidget {
  final VoidCallback onTextPressed;

  const _BottomPart({
    Key? key,
    required this.onTextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
