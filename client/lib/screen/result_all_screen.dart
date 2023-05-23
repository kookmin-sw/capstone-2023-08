import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:client/layout/default_layout.dart';
import 'package:client/screen/fail_screen.dart';
import 'package:client/screen/result_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../constant/page_url.dart';
import '../dio/dio.dart';
import '../secure_storage/secure_storage.dart';
import 'loading_screen.dart';
import 'loading_success_screen.dart';
import 'package:image/image.dart' as img;

class FittingScreen extends ConsumerStatefulWidget {

  FittingScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<FittingScreen> createState() => _FittingScreenState();
}

class _FittingScreenState extends ConsumerState<FittingScreen> {
  final dio = Dio();

  // 서버에서 이미지 결과를 가져오는 코드
  Future<File?> requestResult() async {
    Response response;
    try {
      final storage = ref.read(secureStorageProvider);
      final id = await storage.read(key: USER_ID);

      /*dio.options.headers = {'accessToken': 'true'};
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );*/
      dio.options = BaseOptions(
        responseType: ResponseType.bytes,
      );
      response = await dio.post(
        RESULT_INFER_URL,
        data: json.encode({
          'user_id': id,
          'cloth_img_path': '${id}_cloth.png',
        }),
      );

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String path = '$tempPath/${id}_result.png';
      File file = File(path);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return File(path);
    } on DioError catch (e) {
      print(e.response);
    }
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
                return LoadingSuccessScreen(imageFile: snapshot.data!);
              } else {
                return const FailScreen();
              }
            }
          }),
    );
  }
}
