import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.item.id) == true) {
        //화면이 변경될 때
        setState(() {
          isLiked = true;
        });
      }
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
    String token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg0MjI3NjE3LCJpYXQiOjE2ODM2MjI4MTcsImp0aSI6IjU2ODk1ZWQxNDk1ZTRiMTY5Njc4MDZjYmU2NTkxZmZmIiwidXNlcl9pZCI6InRlc3QifQ.LreSws7aQTNVhfWZCyVhEH0FfND72OsFoGOfAqCKWCY';

    formData.user_id = "test";
    formData.goods_id = widget.item.id.toString();

    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.item.id);
      } else {
        likedToons.add(widget.item.id);
      }
      //핸드폰 저장소에 다시 List를 저장
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }

    if (isLiked == true) {
      var result = await http.post(
        Uri.parse('http://35.84.85.252:8000/goods/dips/add'),
        headers: {'Authorization': 'Bearer $token'},
        body: json.encode(formData.toJson()),
      );
      print("like를 눌러서 post해 DB에 ADD했어여");
      if (result.statusCode != 200) {
        print("찜 추가 실패_add");
      }
    } else {
      var result = await http.delete(
        Uri.parse('http://35.84.85.252:8000/goods/dips/delete'),
        headers: {'Authorization': 'Bearer $token'},
        body: json.encode(formData.toJson()),
      );
      if (result.statusCode != 200) {
        print("찜 삭제 실패_delete");
      }
    }
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
                            color: Color.fromARGB(255,255,174,53),
                            icon: Icon(isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined),
                            iconSize: 20.0,
                          ),
                          
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
