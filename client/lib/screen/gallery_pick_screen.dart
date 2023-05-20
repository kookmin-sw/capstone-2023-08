import 'dart:io';

import 'package:client/component/custom_snackbar.dart';
import 'package:client/component/loading_screen.dart';
import 'package:client/constant/colors.dart';
import 'package:client/layout/root_tab.dart';
import 'package:client/screen/fail_screen.dart';
import 'package:client/screen/home_screen.dart';
import '../data/upload_image.dart';
import 'loading_screen.dart';
import 'result_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/page_url.dart';
import '../dio/dio.dart';
import '../layout/default_layout.dart';
import 'package:dio/dio.dart';

import '../secure_storage/secure_storage.dart';

class GalleryPickScreen extends StatefulWidget {
  const GalleryPickScreen({Key? key}) : super(key: key);

  @override
  State<GalleryPickScreen> createState() => _GalleryPickScreenState();
}

class _GalleryPickScreenState extends State<GalleryPickScreen> {
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
                          Text('이런 사진이 좋아요',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8.0),
                          Text(
                            '배경이 없는 사진을 선택하면, 좋은 결과를 얻을 수 있어요',
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Image.asset(
                            'asset/clothes/product-image.png',
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
      ).whenComplete(() async {
        final bool result = await pickImage();
        if (result == false)
          Navigator.of(context).pop();
      });
    });
  }

  Future<bool> pickImage() async {
    // get image from gallery
    XFile? tempImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempImage == null) return false;
    setState(() {
      print('setState');
      image = tempImage;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return image == null? Container() : PickedImageSendScreen(image: image!);
  }
}

class PickedImageSendScreen extends ConsumerStatefulWidget {
  final XFile image;

  const PickedImageSendScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  ConsumerState<PickedImageSendScreen> createState() =>
      _PickedImageSendScreenState();
}

class _PickedImageSendScreenState extends ConsumerState<PickedImageSendScreen> {
  @override
  Widget build(BuildContext context) {
    Future<bool> pickImageAndUpload() async {
      try {
        final imageFile = File(widget.image!.path);

        final dio = Dio();
        final storage = ref.read(secureStorageProvider);
        final upload = UploadImage(
            dio: dio, storage: storage, context: context, image: imageFile);

        // get id
        final id = await storage.read(key: USER_ID);
        if (id == null) return false;

        // upload image to s3
        await upload.getImageAndUpload(id);

        return true;
      } catch (e) {
        print('Failed to pick image: $e');
        return false;
      }
    }

    return DefaultLayout(
      backgroundColor: PRIMARY_BLACK_COLOR,
      child: FutureBuilder(
          future: pickImageAndUpload(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // not data
                /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> RootTab()), (route) => false);
                CustomSnackBar(text: '이미지를 선택해주세요', context: context);*/
                print('error');
                return Container(
                  color: Colors.black,
                );
              } else {
                if (snapshot.hasData == false) {
                  print('done & no data');
                  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> RootTab()), (route) => false);
                  return Container(
                    color: Colors.black,
                  );
                } else {
                  print('done & have data & ${snapshot.data}');
                  return FittingScreen(
//                  image: snapshot.data!, // todo: 이 부분 없애기
                      );
                }
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              if (snapshot.hasData == false)
                print('waiting & no data');
              else
                print('waiting & have data');
              return const DefaultLoadingScreen(
                backgroundColor: Colors.black,
              );
            } else {
              return Container(
                color: Colors.black,
              );
            }
          }),
    );
  }
}
