import 'dart:io';
import 'dart:typed_data';

import 'package:client/component/custom_snackbar.dart';
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
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RootTab()), (route) => false);
    }

    Future<bool> onGallerySavedPressed() async {
      print('gallery pressed');
      var now = new DateTime.now();
      final Uint8List bytes = await widget.imageFile.readAsBytesSync();
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 60,
          name:
              '${now.year}${now.month}${now.day}_${now.hour}${now.hour}${now.second}_chackboot.png');
      print('피팅사진제목 : ${now}-chackboot.png');

      onReturnPressed();

      final snackBar =
          CustomSnackBar(context: context, text: '갤러리에 사진이 저장되었습니다!');
      snackBar.renderSnackBar();

      return true;
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

    Future<void> onBadPressed() async {
      final storage = ref.watch(secureStorageProvider);
      final String? user_id = await storage.read(key: USER_ID);
      if (user_id == null) return;

      // if token uses
      dio.options.headers = {'accessToken': 'true'};
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );

      Response response = await dio.post(FEEDBACK_URL, data: {
        'user_id': user_id,
      });
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
            const SizedBox(height: 16.0),
            Expanded(
              child: Image.file(
                widget.imageFile,
                filterQuality: FilterQuality.high,
                width: width * 0.9,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_BLACK_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        content: Builder(
                          builder: (context) {
                            double height = MediaQuery.of(context).size.height;
                            double width = MediaQuery.of(context).size.width;
                            return SizedBox(
                              height: height * 0.23,
                              width: width,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
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
                                          constraints: const BoxConstraints(),
                                          iconSize: 45.0,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
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
                                          constraints: const BoxConstraints(),
                                          iconSize: 45.0,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
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
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
