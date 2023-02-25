import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _TopText(width: width),
                _MiddleLogin(width: width),
                _BottomLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopText extends StatelessWidget {
  const _TopText({
    Key? key,
    required this.width,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.8,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 19.0),
            child: Column(
              children: [
                Text(
                  'Fit on,',
                  style: TextStyle(
                    fontSize: 28.0, //default : 14
                  ),
                ),
                Text(
                  'Fit me!',
                  style: TextStyle(
                    fontSize: 28.0, //default : 14
                  ),
                ),
              ],
            ),
          ),
          Text(
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
  const _MiddleLogin({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
            child: SizedBox(
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  TextField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'UserID',
                    ),
                  ),
                  TextField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width * 0.8,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('로그인'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomLink extends StatelessWidget {
  const _BottomLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton(onPressed: () {}, child: Text('아이디찾기')),
              TextButton(onPressed: () {}, child: Text('비밀번호찾기')),
              TextButton(onPressed: () {}, child: Text('회원가입')),
            ],
          ),
        ],
      ),
    );
  }
}
