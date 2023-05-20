import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';

class FindAccountScreen extends StatelessWidget {
  const FindAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text('아이디, 비밀번호 찾기'),
      ),
    );
  }
}
