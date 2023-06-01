import 'package:client/component/loading_screen.dart';
import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import '../dio/dio.dart';
import '../secure_storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_detail_screen.dart';

import '../constant/page_url.dart';

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

Future<List<cloth>> fetchcloth(FlutterSecureStorage storage) async {
  final dio = Dio(
    BaseOptions(
      headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
    ),
  );
  dio.interceptors.add(
    CustomInterceptor(storage: storage),
  );
  Response resp = await dio.post(
    GOODS_SHOW_URL,
  );

  if (resp.statusCode == 200) {
    Map body = resp.data;
    List<dynamic> data = body['data'];
    var data2 = [];
    for (int i = 0; i < data.length; i++) {
      data2.add(data[i]['goods_info']);
    }

    var real = data2.map((item) => cloth.fromJson(item)).toList();
    return real;
  } else {
    throw Exception('Failed to load album');
  }
}

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Favoritetest(),
    );
  }
}

class Favoritetest extends ConsumerWidget {
  const Favoritetest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<String?> getUserName() async {
      final storage = ref.watch(secureStorageProvider);
      final user_name = await storage.read(key: USER_NAME);
      print(user_name);
      return user_name;
    }

    return Material(
        child: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            toolbarHeight: 60,
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            centerTitle: false,
            title: Transform(
                transform: Matrix4.translationValues(0.0, 0.0, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    FutureBuilder(
                      future: getUserName(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData == true) {
                          return Text(
                            '${snapshot.data}',
                            style: const TextStyle(
                              fontSize: 33.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Text(
                      " 님이 좋아하는 옷이에요!",
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          fontFamily: "Pretendard",
                          color: Colors.black),
                    ),
                  ],
                )),
          ),
        ];
      },
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Favorite(),
          ),
        ],
      ),
    ));
  }
}

class Favorite extends ConsumerStatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _favorite createState() => _favorite();
}

class _favorite extends ConsumerState<Favorite> {
  //const FirstTabScreen({Key? key}) : super(key: key);
  late Future<List<cloth>> futurecloth;

  @override
  void initState() {
    final storage = ref.read(secureStorageProvider);
    futurecloth = fetchcloth(storage);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<cloth>>(
      future: futurecloth,
      // this is a code smell. Make sure that the future is NOT recreated when build is called. Create the future in initState instead.
      builder: (context, snapshot) {
        Widget newsListSliver;
        if (snapshot.hasData) {
          newsListSliver = SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (width / 2) / (120 + 200),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index < snapshot.data!.length) {
                    return ProductItem(
                      id: snapshot.data![index].id,
                      imageUrl: snapshot.data![index].s3_img_url,
                      productName: snapshot.data![index].goods_name,
                      brand: snapshot.data![index].brand_name,
                    );
                  }
                }),
              ));
        } else {
          newsListSliver = SliverToBoxAdapter(
            child: DefaultLoadingScreen(),
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

class ProductItem extends ConsumerStatefulWidget {
  const ProductItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.brand,
    // required this.favorite,
  }) : super(key: key);

  final int id;
  final String imageUrl;
  final String productName;
  final String brand;

  @override
  ConsumerState<ProductItem> createState() => _productitem();
}

class _productitem extends ConsumerState<ProductItem> {
  FavoriteFormData formData = FavoriteFormData();
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs(FlutterSecureStorage storage) async {
    var user = await storage.read(key: USER_ID);
    user = user.toString();
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons' + user);
    if (likedToons != null) {
      //화면이 변경될 때
      setState(() {
        //isLiked = likedToons.contains(widget.id.toString());
        isLiked = true;
      });
    } else {
      await prefs.setStringList('likedToons'+user, []);
    }
  }

  @override
  void initState() {
    final storage = ref.read(secureStorageProvider);
    initPrefs(storage);
    super.initState();
    //initPrefs();
    // if(Platform.isAndroid){
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }

  onFavorite() async {
    final storage = ref.read(secureStorageProvider);

    formData.user_id = await storage.read(key: USER_ID);
    formData.goods_id = widget.id.toString();

    final likedToons = prefs.getStringList('likedToons' + formData.user_id.toString());
    setState(() {
      isLiked = !isLiked;
      print("setstate");
    });
    if (likedToons != null) {
      if (isLiked) {
        likedToons.add(widget.id.toString());
        // likedToons.remove(widget.id);
      } else {
        likedToons.remove(widget.id.toString());
        // likedToons.add(widget.id);
      }
      //핸드폰 저장소에 다시 List를 저장
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList('likedToons' + formData.user_id.toString(), likedToons);
    }

    if (isLiked == true) {
      final dio = Dio(
        BaseOptions(
          headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
        ),
      );
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );
      Response resp = await dio.post(
        GOODS_ADD_URL,
        data: json.encode(formData.toJson()),
      );
      print("like를 눌러서 post해 DB에 ADD했어여");
      if (resp.statusCode != 200) {
        print("찜 추가 실패_add");
      }
    } else {
      final dio = Dio(
        BaseOptions(
          headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
        ),
      );
      dio.interceptors.add(
        CustomInterceptor(storage: storage),
      );
      Response resp = await dio.delete(
        GOODS_DELETE_URL,
        data: json.encode(formData.toJson()),
      );
      if (resp.statusCode != 200) {
        print("찜 삭제 실패_delete");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(
                      item: ProductItem(
                          id: widget.id,
                          imageUrl: widget.imageUrl,
                          productName: widget.productName,
                          brand: widget.brand)))).then((value) {
            final storage = ref.read(secureStorageProvider);
            initPrefs(storage);
            fetchcloth(storage);
          });
        },
        child: Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  widget.imageUrl,
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              //SizedBox(height: 5.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 8.0),
                  child: Text(
                    widget.brand,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Color.fromARGB(255, 71, 71, 71),
                    ),
                  ),
                ),
                //SizedBox(width: 0),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8.0),
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Icon(
                      isLiked
                          ? Icons.favorite
                          : Icons.favorite_outline_outlined,
                      size: 20,
                      color: const Color.fromARGB(255, 255, 174, 53),
                    ),
                  ),
                ),
              ]),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 8.0),
                      child: Text(widget.productName,
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
