import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'loading_screen.dart';
import 'loading_success_screen.dart';
import 'package:image_picker/image_picker.dart';

class FittingScreen extends StatefulWidget {
  const FittingScreen({Key? key}) : super(key: key);

  @override
  State<FittingScreen> createState() => _FittingScreenState();
}

class _FittingScreenState extends State<FittingScreen> {
  // todo: 서버에서 이미지 결과를 가져오는 코드 필요
  // 일단 image picker, 갤러리에서 가져오도록 설정
  Future<XFile?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: pickImage(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData == false) {
              return const LoadingScreen();
            } else {
              if (snapshot.data != null) {
                return LoadingSuccessScreen(
                  imageFile: File(snapshot.data!.path), //todo: image 객체 반환
                );
              } else {
                return const Center(
                  child: Text('image 선택 필요'),
                );
              }
            }
          }),
    );
  }
}
