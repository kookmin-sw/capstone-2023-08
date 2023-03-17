import 'package:flutter/material.dart';

class SignupSuccess extends StatelessWidget {
  const SignupSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          //Navigator.of(context).popUntil((route) => '/');
        child: Text('저장 성공!'),
      ),
    );
  }
}
