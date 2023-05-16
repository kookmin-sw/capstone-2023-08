import 'dart:io';
import 'dart:typed_data';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:client/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../component/default_dialog.dart';
import '../constant/colors.dart';
import '../layout/root_tab.dart';

class ResultScreen extends StatefulWidget {
  File imageFile;

  ResultScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    Future<void> onBadPressed() async {
      // todo: 서버에 결과 저장
    }
    void onReturnPressed() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    void onGallerySavedPressed() async {
      print('gallery pressed');
      var now = new DateTime.now();
      final Uint8List bytes = await widget.imageFile.readAsBytesSync();
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 60, name: '${now}-chackboot.png');
      print('result ${result.toString()}');

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);

      AnimatedSnackBar(
        duration: Duration(seconds: 2),
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        builder: ((context) {
          return Container(
            width: width,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xDD000000),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Colors.white,),
                SizedBox(width: 16.0,),
                const Text(
                  '피팅 사진이 저장되었습니다!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }),
      ).show(context);
    }

    Future onGoodPressed() {
      Navigator.of(context, rootNavigator: true).pop();

      return showDialog(
        context: context,
        builder: (context) {
          return BasicAlertDialog(
            title: '피팅 사진이 마음에 든다면',
            leftButtonText: '처음으로',
            rightButtonText: '사진저장',
            onLeftButtonPressed: onReturnPressed,
            onRightButtonPressed: onGallerySavedPressed,
          );
        },
      );
    }

    return DefaultLayout(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'asset/img/logo.png',
                    width: width * 0.25,
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Image.file(
                widget.imageFile,
                width: width,
              ),
              SizedBox(
                height: 16.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 45.0,
                  child: ElevatedButton(
                    child: Text('다음'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_BLACK_COLOR,
                      side: BorderSide(),
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            content: Builder(
                              builder: (context) {
                                double height =
                                    MediaQuery.of(context).size.height;
                                double width =
                                    MediaQuery.of(context).size.width;
                                return Container(
                                  height: height * 0.23,
                                  width: width,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '피팅 사진을 평가해 주세요!',
                                              //피팅 사진이 마음에 든다면,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: PRIMARY_BLACK_COLOR,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '결과에 따라 피팅 결과가 저장될 수 있습니다',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              iconSize: 45.0,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              alignment: Alignment.center,
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.thumb_down,
                                                color: Colors.black,
                                              ),
                                              style: IconButton.styleFrom(
                                                elevation: 0,
                                              ),
                                            ),
                                            IconButton(
                                              iconSize: 45.0,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              alignment: Alignment.center,
                                              onPressed: onGoodPressed,
                                              icon: Icon(
                                                Icons.thumb_up,
                                                color: Colors.black,
                                              ),
                                              style: IconButton.styleFrom(
                                                elevation: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
