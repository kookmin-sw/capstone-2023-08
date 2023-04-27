import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
      print('pop pressed');
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
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return BasicAlertDialog(
                          onFirstPagePressed: onFirstPagePressed,
                          onGallerySavedPressed: onGallerySavedPressed,
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

class AlertButton extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final String label;
  final VoidCallback onPressed;

  const AlertButton({
    Key? key,
    required this.backgroundColor,
    required this.color,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 45.0,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

class BasicAlertDialog extends StatelessWidget {
  final VoidCallback onFirstPagePressed;
  final VoidCallback onGallerySavedPressed;

  const BasicAlertDialog({
    Key? key,
    required this.onFirstPagePressed,
    required this.onGallerySavedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            height: height * 0.23,
            width: width,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '피팅 사진이 마음에 들면,',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'AI가 생성한 사진을 갤러리에 저장해주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AlertButton(
                        backgroundColor: Colors.white70,
                        color: Colors.indigo,
                        label: '처음으로',
                        onPressed: this.onFirstPagePressed,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      AlertButton(
                        backgroundColor: Colors.indigo,
                        color: Colors.white,
                        label: '갤러리 저장',
                        onPressed: this.onGallerySavedPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
