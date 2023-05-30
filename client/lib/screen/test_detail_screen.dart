import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:client/data/upload_image.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import '../dio/dio.dart';
import '../layout/root_tab.dart';
import '../secure_storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'result_all_screen.dart';
import '../constant/page_url.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DetailScreen());
}

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({Key? key, this.item}) : super(key: key);

  final item;
  

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class FavoriteFormData {
  String? user_id;
  String? goods_id;

  FavoriteFormData({this.user_id, this.goods_id});

  Map<String, dynamic> toJson() => {'user_id': user_id, 'goods_id': goods_id};
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  FavoriteFormData formData = FavoriteFormData();
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      //화면이 변경될 때
      setState(() {
        isLiked = likedToons.contains(widget.item.id.toString());
      });
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    // if(Platform.isAndroid){
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }

  onFavorite() async {
    //찜 API 연결
    //String token = '';
    final storage = ref.read(secureStorageProvider);

    formData.user_id = await storage.read(key: USER_ID);
    formData.goods_id = widget.item.id.toString();

    final likedToons = prefs.getStringList('likedToons');
    setState(() {
      isLiked = !isLiked;
    });
    if (likedToons != null) {
      if (isLiked) {
        likedToons.add(widget.item.id.toString());
        // likedToons.remove(widget.id);
      } else {
        likedToons.remove(widget.item.id.toString());
        // likedToons.add(widget.id);
      }
      //핸드폰 저장소에 다시 List를 저장
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList('likedToons', likedToons);
    }
    //user_id 필요

    if (isLiked == true) {
      // var result = await http.post(
      //   Uri.parse('http://35.84.85.252:8000/goods/dips/add'),
      //   headers: {'Authorization': 'Bearer $token'},
      //   body: json.encode(formData.toJson()),
      // );
      final dio = Dio(
        BaseOptions(
          headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
        ),
      );
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );
      Response resp = await dio.post(
        'http://35.84.85.252:8000/goods/dips/add',
        data: json.encode(formData.toJson()),
      );
      print("like를 눌러서 post해 DB에 ADD했어여");
      if (resp.statusCode != 200) {
        print("찜 추가 실패_add");
      }
    } else {
      // var result = await http.delete(
      //   Uri.parse('http://35.84.85.252:8000/goods/dips/delete'),
      //   headers: {'Authorization': 'Bearer $token'},
      //   body: json.encode(formData.toJson()),
      // );
      final dio = Dio(
        BaseOptions(
          headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
        ),
      );
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );
      Response resp = await dio.delete(
        'http://35.84.85.252:8000/goods/dips/delete',
        data: json.encode(formData.toJson()),
      );
      if (resp.statusCode != 200) {
        print("찜 삭제 실패_delete");
      }
    }
  }

  onFitting() async {
    final dio = Dio();
    final storage = ref.read(secureStorageProvider);
    //final image = Image.network(widget.item.imageUrl);
    var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getApplicationDocumentsDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File image = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(Uri.parse(widget.item.imageUrl));
// // write bodyBytes received in response to file.
//     await image.writeAsBytes(response.bodyBytes);
      var data = await http.get(Uri.parse(widget.item.imageUrl));
      var bytes = data.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final name = p.join(dir.path, (rng.nextInt(100)).toString() + '.png');//From Alberto Miola's answer
      File file = File(name);
      print(dir.path);
      File image = await file.writeAsBytes(bytes);
    
    final upload =
        UploadImage(isCloth: true, dio: dio, storage: storage, context: context, image: image);

    String id = await upload.getUserInfoFromStorage();
    await upload.getImageAndUpload(id);

    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FittingScreen(),
        ),
);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var finalWidth = 390;
    var finalHeight = 844;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          child: Builder(
            builder: (BuildContext context) {
              return WebView(
                initialUrl: 'https://www.musinsa.com/app/goods/' +
                    widget.item.id.toString(),
                javascriptMode: JavascriptMode.disabled,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              );
            },
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              child: SizedBox(
                  width: 393 * (screenWidth / finalWidth),
                  height: 110 * (screenHeight / finalHeight) - 15,
                  child: ColoredBox(
                      color: const Color.fromARGB(255, 242, 242, 242),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onFavorite,
                            //alignment: Alignment.centerLeft,
                            color: const Color.fromARGB(255, 255, 174, 53),
                            icon: Icon(isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined),
                            iconSize: 25.0,
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            //alignment: Alignment.centerRight,
                            width: 300 * (screenWidth / finalWidth),
                            height: 55 * (screenHeight / finalHeight),
                            //margin: const EdgeInsets.all(10.0),
                            //padding: EdgeInsets.fromLTRB(0, 5, 2, 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                elevation: 0,
                              ),
                              onPressed: onFitting,
                              child: const Text(
                                '피팅하기',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        ],
                      ))),
            )),
        Positioned(
          top: 0,
          child: Container(
            child: SizedBox(
                width: 393 * (screenWidth / finalWidth),
                height: 100 * (screenHeight / finalHeight),
                child: ColoredBox(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Container(
                        //   //alignment: Alignment.bottomCenter,
                        //   child: Image.asset(
                        //     "asset/logo_black.png",
                        //     width: 50,
                        //     height: 50,
                        //     //alignment: Alignment.bottomCenter,
                        //   ),
                        // ),
                        IconButton(
                          //alignment: Alignment.bottomLeft,
                          icon: const Icon(Icons.arrow_back
                              //isFavorite ? Icons.favorite : Icons.favorite_border,
                              //color: isFavorite ? Colors.red : null,
                              ),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // Text(
                        //   widget.item.brand,
                        //   style: TextStyle(
                        //       fontSize: 15, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ))),
          ),
        )
      ],
    ));
  }
}
