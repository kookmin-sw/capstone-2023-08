import 'dart:io';
import 'dart:async';

import 'package:client/layout/default_layout.dart';
import 'package:client/screen/fail_screen.dart';
import 'package:flutter/material.dart';

import 'loading_screen.dart';
import 'loading_success_screen.dart';
import 'package:image_picker/image_picker.dart';

class FittingScreen extends StatefulWidget {
  final File image;

  FittingScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<FittingScreen> createState() => _FittingScreenState();
}

class _FittingScreenState extends State<FittingScreen> {
  // todo: 서버에서 이미지 결과를 가져오는 코드 필요
  Future<File?> requestResult() async {
    try {
      // input?

    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: FutureBuilder(
          future: requestResult(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData == false) {
              return const LoadingScreen();
            } else {
              if (snapshot.data != null) {
                return LoadingSuccessScreen(
                  imageFile: snapshot.data!, //todo: image 객체 반환
                );
              } else {
                return FailScreen();
              }
            }
          }),
    );
  }
}
