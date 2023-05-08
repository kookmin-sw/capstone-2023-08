import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, this.item}) : super(key: key);

  final item;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class FavoriteFormData {
  String? user_id;
  String? goods_id;

  FavoriteFormData({this.user_id, this.goods_id});

  Map<String, dynamic> toJson() => {'user_id': user_id, 'goods_id': goods_id};
}

class _DetailScreenState extends State<DetailScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  FavoriteFormData formData = FavoriteFormData();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // if(Platform.isAndroid){
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }

  onFavorite() async {
    //찜 API 연결
    formData.user_id = "test";
    formData.goods_id = widget.item.id.toString();

    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked == true) {
      var result = await http.post(
        Uri.parse('http://35.84.85.252:8000/goods/dips/add'),
        body: json.encode(formData.toJson()),
      );
      print("like를 눌러서 post해 DB에 ADD했어여");
      if (result.statusCode != 200) {
      print("찜 추가 실패");
    }
    }
    else {
      var result = await http.post(
        Uri.parse('http://35.84.85.252:8000/goods/dips/delete'),
        body: json.encode(formData.toJson()),
      );
      if (result.statusCode != 200) {
      print("찜 추가 실패");
    }
    }
    // if (isLiked == false) {
    //   setState(() {
    //     isLiked = !isLiked;
    //   });
    //   var result = await http.post(
    //     Uri.parse('http://35.84.85.252:8000/goods/dips/add'),
    //     body: json.encode(formData.toJson()),
    //   );
    //   if (result.statusCode != 200) {
    //     print("찜 추가 실패");
    //   }
    // } else {
    //   setState(() {
    //     isLiked = !isLiked;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          child: Builder(
            builder: (BuildContext context) {
              return WebView(
                initialUrl: 'https://www.musinsa.com/app/goods/' +
                    widget.item.id.toString(),
                javascriptMode: JavascriptMode.unrestricted,
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
                  width: 393,
                  height: 110,
                  child: ColoredBox(
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 20),
                          IconButton(
                            onPressed: onFavorite,
                            //alignment: Alignment.centerLeft,
                            icon: Icon(isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined),
                            iconSize: 20.0,
                          ),
                          // Container(
                          //   width: 50,
                          //   height: 50,
                          //   padding: EdgeInsets.fromLTRB(30, 10, 15, 10),
                          //   child: IconButton(
                          //     onPressed: onFavorite,
                          //     //alignment: Alignment.centerLeft,
                          //     icon: Icon(isLiked
                          //         ? Icons.favorite
                          //         : Icons.favorite_outline_outlined),
                          //     iconSize: 20.0,
                          //   ),
                          //                   child: ElevatedButton.icon(
                          //   // 텍스트버튼에 아이콘 넣기
                          //   onPressed: onFavorite, // 버튼 클릭 비활성화 -> 비활성화 시의 UI는 onSurface로 가능
                          //   icon: Icon(isLiked
                          //                         ? Icons.favorite
                          //                         : Icons.favorite_outline_outlined, size: 23),
                          //   label: Text('GO to home'),
                          // ),
                          //),
                          SizedBox(width: 20),
                          Container(
                            //alignment: Alignment.centerRight,
                            width: 270,
                            height: 50,
                            //margin: const EdgeInsets.all(10.0),
                            //padding: EdgeInsets.fromLTRB(0, 5, 2, 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: Text('피팅하기'),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ))),
            )),
        Positioned(
          top: 0,
          child: Container(
            child: SizedBox(
                width: 393,
                height: 100,
                child: ColoredBox(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            "assets/logo.png",
                            width: 50,
                            height: 50,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            //alignment: Alignment.bottomLeft,
                            icon: Icon(Icons.arrow_back
                                //isFavorite ? Icons.favorite : Icons.favorite_border,
                                //color: isFavorite ? Colors.red : null,
                                ),
                            iconSize: 20.0,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ))),
          ),
        )
      ],
    ));
  }
}
