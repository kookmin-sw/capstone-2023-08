import 'dart:io';

import 'package:client/component/one_button_dialog.dart';
import 'package:client/screen/result_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../layout/default_layout.dart';

class GalleryPickScreen extends StatefulWidget {
  const GalleryPickScreen({Key? key}) : super(key: key);

  @override
  State<GalleryPickScreen> createState() => _GalleryPickScreenState();
}

class _GalleryPickScreenState extends State<GalleryPickScreen> {
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
    return DefaultLayout(
      child: FutureBuilder(
          future: pickImage(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData == false) {
              return Center(child: CircularProgressIndicator(),);
            } else {
              if (snapshot.data != null) {
                return FittingScreen(image: File(snapshot.data!.path));
              } else {
                // todo: oneButtonDialog로 이미지 선택하도록 변경 (아마 쓰일일은 없을거지만..)
                return DefaultLayout(title: '이미지 선택', child: Center(child: Text('이미지 선택필요'),));
              }
            }
          }),
    );
  }
}
