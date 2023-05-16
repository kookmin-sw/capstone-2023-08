import 'dart:io';

import 'package:client/constant/colors.dart';
import 'package:client/screen/result_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/page_url.dart';
import '../layout/default_layout.dart';
import 'package:dio/dio.dart';

import '../secure_storage/secure_storage.dart';

class GalleryPickScreen extends ConsumerStatefulWidget {
  const GalleryPickScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GalleryPickScreen> createState() => _GalleryPickScreenState();
}

class _GalleryPickScreenState extends ConsumerState<GalleryPickScreen> {
  XFile? image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 350,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('이런 사진이 좋아요!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: 8.0),
                          Text('배경이 없는 사진을 선택하면,더 나은 결과를 얻을 수 있습니다',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          Image.asset(
                            'asset/clothes/product-image.jpg',
                            width: 150,
                          ),
                        ],
                      ),
                    ),
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('확인'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).whenComplete(() => pickImage());
    });
  }

  final dio = Dio();

  Future<String> getPresignedUrl(String id) async {
    try {
      String bucket_name = 'user-cloth-img';
      String image_name = '${id}_cloth.png';
      Response response = await dio.request(
        GET_PRESIGNED_URL,
        data: <String, String>{
          'bucket_name': bucket_name,
          'file_path': image_name
        },
        options: Options(method: 'GET'),
      );
      return response.data['data'];
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<bool> uploadToPresignedURL(File file, String url) async {
    Response response;
    try {
      response = await dio.put(
        url,
        data: file.openRead(),
        options: Options(
          contentType: "image/png",
          // todo: image type에 따라 content type 변경..?????
          headers: {
            "Content-Length": file.lengthSync(),
          },
        ),
      );
      if (response.statusCode == 200) return true;
      return false;
    } on DioError catch (e) {
      print(e.response);
      return false;
    }
  }

  Future<bool> getImageAndUpload(File image, String id) async {
    // 1. presigned url 생성 확인
    String url = await getPresignedUrl(id);

    // 2. S3 upload
    bool isUploaded = await uploadToPresignedURL(image, url);

    return isUploaded;
  }

  Future<void> pickImage() async {
    // get image from gallery
    XFile? tempImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempImage == null) return;
    setState(() {
      print('setState');
      image = tempImage;
    });
  }

  Future<File?> pickImageAndUpload() async {
    try {
      // get image(XFile) to file
      final imageFile = File(image!.path);
      return imageFile; // todo : 이 부분 없애기

      // get id
      final storage = ref.read(secureStorageProvider);
      final id = await storage.read(key: USER_ID);
      if (id == null) return null;

      // upload image to s3
      await getImageAndUpload(imageFile, id!);

      return imageFile;
    } catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_BLACK_COLOR,
      child: FutureBuilder(
          future: pickImageAndUpload(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(color: PRIMARY_BLACK_COLOR),
              );
            } else {
              if (snapshot.data != null) {
                return FittingScreen(image: snapshot.data!); // todo: 파라미터 없애기
              } else {
                return DefaultLayout(
                    title: '이미지 선택',
                    child: Center(
                      child: Text('이미지 선택필요'),
                    ));
              }
            }
          }),
    );
  }
}
