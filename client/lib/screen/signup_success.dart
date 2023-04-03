import 'dart:async';

import '../constant/page_name.dart';
import 'package:flutter/material.dart';

class SignupSuccess extends StatefulWidget {
  const SignupSuccess({Key? key}) : super(key: key);

  @override
  State<SignupSuccess> createState() => _SignupSuccessState();
}

class _SignupSuccessState extends State<SignupSuccess> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.of(context).popUntil(ModalRoute.withName(HOME_SCREEN));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('저장 성공!'),
    );
  }
}
