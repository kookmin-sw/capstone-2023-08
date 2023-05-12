import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'shoppingmall_screen.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_detail_screen.dart';

class cloth {
  int id;
  String goods_name;
  String brand_name;
  String s3_img_url;

  cloth(
      {required this.id,
      required this.goods_name,
      required this.brand_name,
      required this.s3_img_url});

  factory cloth.fromJson(Map<String, dynamic> json) {
    return cloth(
      id: json['id'],
      goods_name: json['goods_name'],
      brand_name: json['brand_name'],
      s3_img_url: json['s3_img_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goods_name'] = this.goods_name;
    data['brand_name'] = this.brand_name;
    data['s3_img_url'] = this.s3_img_url;
    return data;
  }
}

class Data {
  String clothData;

  Data({required this.clothData});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      clothData: json['goods_info'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_info'] = this.clothData;
    return data;
  }
}

class ForFavorite {
  String? user;

  ForFavorite({this.user});

  Map<String, dynamic> toJson() => {'user_id': user};
}

Future<List<cloth>> fetchcloth() async {
  String token = '';
  ForFavorite formData = ForFavorite();
  formData.user = 'test';
  final response = await http.post(
      Uri.parse('http://35.84.85.252:8000/goods/dips/show'),
      headers: {'Authorization': 'Bearer $token'},
      body: json.encode(formData.toJson()));
  // final response =
  //     await http.get(Uri.parse('http://35.84.85.252:8000/goods/cloth-list'));

  if (response.statusCode == 200) {
    Map body = json.decode(response.body);
    List<dynamic> data = body['data'];
    var data2 = [];
    for (int i = 0; i < data.length; i++) {
      data2.add(data[i]['goods_info']);
    }
    // var allInfo = data.map((item) => Data.fromJson(item)).toList();
    // print(allInfo);
    var real = data2.map((item) => cloth.fromJson(item)).toList();
    return real;
  } else {
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(const FavoriteScreen());
}

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 안드로이드에서 StatusBar의 색과 안드로이드와 iOS 모두에서 StatusBar 아이콘 색상을
    // 설정하기 위해 AnnotatedRegion을 사용함.
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Favoritetest(),
      ),
    );
  }
}

class Favoritetest extends StatelessWidget {
  const Favoritetest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              toolbarHeight: 45,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: true,
              //title: Text
              // leading: Padding(
              //   padding: const EdgeInsets.only(top: 28.0),
              //   child: Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   //textBaseline: TextBaseline.alphabetic,
              //   children: [
              //     // Container(
              //     //     alignment: Alignment.bottomCenter,
              //     //     child: RichText(
              //     //         textAlign: TextAlign.center,
              //     //         text: TextSpan(children: [
              //     //           TextSpan(
              //     //               text: 'Fit on, ',
              //     //               style: TextStyle(
              //     //                   fontSize: 25, color: Colors.grey)),
              //     //           TextSpan(
              //     //               text: 'Fit me!',
              //     //               style: TextStyle(
              //     //                   fontSize: 25, color: Colors.black)),
              //     //         ]))),
              //     IconButton(
              //       //alignment: Alignment.bottomLeft,
              //       icon: Icon(Icons.arrow_back_ios_new_rounded),
              //       iconSize: 20.0,
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => MyApp()));
              //       },
              //     ),
              //   ],
              // ),
              // ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: const Icon(Icons.arrow_back_ios_new_rounded),
              //     //tooltip: 'Add new entry',
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => MyApp()));
              //     },
              //   ),
              // ]
            ),
            // 변경사항
            // SliverOverlapAbsorber(
            //   handle:
            //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            //   sliver: const SliverPersistentHeader(
            //       pinned: true, delegate: TabBarDelegate()),
            // ),
          ];
        },
        body: Favorite());
  }
}

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _favorite createState() => _favorite();
}

class _favorite extends State<Favorite> {
  //const FirstTabScreen({Key? key}) : super(key: key);
  late Future<List<cloth>> futurecloth;

  @override
  void initState() {
    futurecloth = fetchcloth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<cloth>>(
      future:
          futurecloth, // this is a code smell. Make sure that the future is NOT recreated when build is called. Create the future in initState instead.
      builder: (context, snapshot) {
        Widget newsListSliver;
        if (snapshot.hasData) {
          newsListSliver = SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index < snapshot.data!.length) {
                return ProductItem(
                  id: snapshot.data![index].id,
                  imageUrl: snapshot.data![index].s3_img_url,
                  productName: snapshot.data![index].goods_name,
                  brand: snapshot.data![index].brand_name,
                );
              }
            }),
          );
        } else {
          newsListSliver = SliverToBoxAdapter(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
          slivers: <Widget>[newsListSliver],
        );
      },
    );
  }
}

class Product {
  final String name;
  final int price;
  final String imageUrl;

  const Product(
      {required this.name, required this.price, required this.imageUrl});
}

class ProductItem extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String productName;
  final String brand;
  // final String favorite;

  ProductItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.brand,
    // required this.favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(
                      item: ProductItem(
                          id: id,
                          imageUrl: imageUrl,
                          productName: productName,
                          brand: brand))));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3,
              ),
              // Stack(
              //   children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  imageUrl,
                  height: 200.0,
                  width: 200.0,
                ),
              ),
              // 사진 옆에 찜 버튼
              // Positioned(
              //   bottom: 5,
              //   right: 5,
              //   child: IconButton(
              //     //alignment: Alignment.centerLeft,
              //     onPressed: onFavorite,
              //               //alignment: Alignment.centerLeft,
              //     icon: Icon(isLiked
              //                   ? Icons.favorite
              //                   : Icons.favorite_outline_outlined),
              //               iconSize: 15.0,
              //   ),
              // ),
              // ],
              // ),
              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.only(left: 7),
                child: Text(
                  brand,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.0, color: Color.fromARGB(255, 71, 71, 71)),
                ),
              ),
              SizedBox(height: 3.0),
              Padding(
                padding: EdgeInsets.only(left: 7),
                child: Text(
                  productName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
