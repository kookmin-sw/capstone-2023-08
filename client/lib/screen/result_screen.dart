import 'dart:io';
import 'dart:typed_data';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../component/default_dialog.dart';
import '../constant/colors.dart';
import '../dio/dio.dart';
import '../layout/root_tab.dart';

class ResultScreen extends ConsumerStatefulWidget {
  File imageFile;

  ResultScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final dio = Dio();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    void onReturnPressed() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    void onGallerySavedPressed() async {
      print('gallery pressed');
      var now = new DateTime.now();
      final Uint8List bytes = await widget.imageFile.readAsBytesSync();
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 60, name: '${now.year}${now.month}${now.day}_${now.hour}${now.hour}${now.second}_chackboot.png');
      print('피팅사진제목 : ${now}-chackboot.png');

      Navigator.of(context, rootNavigator: true).pop();
      onReturnPressed();

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
            bodyText: '소중한 의견 감사합니다!',
            title: '피팅 사진을 저장하고 싶다면',
            leftButtonText: '처음으로',
            rightButtonText: '사진저장',
            onLeftButtonPressed: onReturnPressed,
            onRightButtonPressed: onGallerySavedPressed,
          );
        },
      );
    }

    // todo: 테스트 시 수정(?)
    // cloth-img는 s3에, person-img도 s3에 올려놓도록 해둬서, user_id만 필요
    Future<void> onBadPressed() async {
      final storage = ref.watch(secureStorageProvider);
      final String? user_id = await storage.read(key: USER_ID);
      if (user_id == null) return;

      // if token uses
      dio.options.headers = {'accessToken': 'true'};
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );

      Response response = await dio.post(
          FEEDBACK_URL,
          data: {
            'user_id' : user_id,
          }
      );
      print(response.data);

      Navigator.of(context, rootNavigator: true).pop();

      return showDialog(
        context: context,
        builder: (context) {
          return BasicAlertDialog(
            bodyText: '소중한 의견 감사합니다!',
            title: '피팅 사진을 저장하고 싶다면',
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
              Expanded(
                child: Image.file(
                  widget.imageFile,
                  filterQuality: FilterQuality.high,
                  width: width * 0.9,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              SizedBox(
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
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: PRIMARY_BLACK_COLOR,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '의견은 더 나은 서비스를 제공을 위해 사용됩니다',
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            softWrap: false,
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
                                            constraints: BoxConstraints(),
                                            iconSize: 45.0,
                                            splashColor: Colors.transparent,
                                            highlightColor:
                                                Colors.transparent,
                                            alignment: Alignment.center,
                                            onPressed: onBadPressed,
                                            icon: const Icon(
                                              Icons.thumb_down,
                                              color: Colors.black,
                                            ),
                                            style: IconButton.styleFrom(
                                              elevation: 0,
                                            ),
                                          ),
                                          IconButton(
                                            constraints: BoxConstraints(),
                                            iconSize: 45.0,
                                            splashColor: Colors.transparent,
                                            highlightColor:
                                                Colors.transparent,
                                            alignment: Alignment.center,
                                            onPressed: onGoodPressed,
                                            icon: const Icon(
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
            ],
          ),
        ),
      ),
    );
  }
}
