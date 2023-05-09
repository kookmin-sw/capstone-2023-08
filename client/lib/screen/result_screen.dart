import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../component/default_dialog.dart';
import '../constant/colors.dart';

class ResultScreen extends StatelessWidget {
  final File imageFile;

  const ResultScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onFirstPagePressed() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    void onGallerySavedPressed() async {
      print('gallery pressed');
      var now = new DateTime.now();
      final Uint8List bytes = await this.imageFile.readAsBytesSync();
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 60, name: '${now}-chackboot.jpg');
      print('result ${result.toString()}');

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Center(
              child:
                  // result image
                  Image.file(this.imageFile),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('다음'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return BasicAlertDialog(
                          onLeftButtonPressed: onFirstPagePressed,
                          onRightButtonPressed: onGallerySavedPressed,
                          title: '피팅 사진이 마음에 들면,',
                          bodyText: 'AI가 생성한 사진을 갤러리에 저장해주세요',
                          leftButtonText: '처음으로',
                          rightButtonText: '갤러리 저장',
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
