import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _TopPart(
                    width: width,
                  ),
                  _MiddleLogin(
                    width: width,
                    idTextEditingController: idTextEditingController,
                    pwTextEditingController: pwTextEditingController,
                    onPressed: onLoginPressed,
                  ),
                  const _BottomPart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginPressed() { // id, pw를 식별하고 확인여부에 따라 다음 페이지로 넘어감.
    print(idTextEditingController.text);
    print(pwTextEditingController.text);
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
    return SizedBox(
      width: width * 0.8,
      child: Column(
        children: [
          Image.asset(
            'asset/img/logo_temporary.png',
            width: width * 0.6,
          ),
          const Text(
            '원하는 옷을 원하는 장소에서 입어보세요!',
            style: TextStyle(
              fontSize: 12.0, //default : 14
            ),
          ),
        ],
      ),
    );
  }
}

class _MiddleLogin extends StatelessWidget {
  final double width;
  final TextEditingController? idTextEditingController;
  final TextEditingController? pwTextEditingController;
  final VoidCallback onPressed;

  const _MiddleLogin({
    Key? key,
    required this.width,
    required this.idTextEditingController,
    required this.pwTextEditingController,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 0.0,
          ),
          child: SizedBox(
            width: width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'UserID',
                  ),
                  controller: idTextEditingController,
                ),

                // 엔터키 누르면 로그인 버튼 눌리는 기능 추가 방법
                // Navigation으로 이동시 textInputAction: TextInputAction.done,
                // onSubmitted : () { // 아이디, 비밀번호 맞는지 확인하고 각각 페이지 보여주는 페이지로 }

                TextField(
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  controller: pwTextEditingController,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: width * 0.8,
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('로그인'),
          ),
        ),
      ],
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {}, child: const Text('아이디찾기')),
            TextButton(
                onPressed: () {}, child: const Text('비밀번호찾기')),
            TextButton(
                onPressed: () {}, child: const Text('회원가입')),
          ],
        ),
      ],
    );
  }
}
