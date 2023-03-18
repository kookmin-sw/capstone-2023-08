import 'package:flutter/material.dart';
import '../constant/page_name.dart';

class SignupSuccess extends StatelessWidget {
  const SignupSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('저장 성공!'),
        ),
        // 1초 뒤 메인화면으로 이동하도록 변경 예정
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.toString() == HOME_SCREEN);
          },
          child: Text('메인화면으로 이동'),
        ),
      ],
    );
  }
}
