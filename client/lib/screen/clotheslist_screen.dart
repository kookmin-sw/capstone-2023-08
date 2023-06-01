import 'package:client/component/loading_screen.dart';
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
import 'dart:async';
import 'login_screen.dart';
import 'test_detail_screen.dart';

import 'dart:convert';
import 'dart:async';
import 'login_screen.dart';
import 'test_detail_screen.dart';

import '../constant/page_url.dart';
import 'package:client/layout/root_tab.dart';

class cloth {
  String id;
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

Future<List<cloth>> fetchcloth(FlutterSecureStorage storage) async {
  final dio = Dio(
    BaseOptions(
      headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
    ),
  );
  dio.interceptors.add(
    CustomInterceptor(storage: storage),
  );
  Response resp = await dio.get(
    LIST_URL,
  );

  if (resp.statusCode == 200) {
    Map body = resp.data;
    List<dynamic> data = body['data'];
    var allInfo = data.map((item) => cloth.fromJson(item)).toList();
    return allInfo;
  } else {
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(ShoppingApp());
}

class ShoppingApp extends ConsumerWidget {
  ShoppingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 안드로이드에서 StatusBar의 색과 안드로이드와 iOS 모두에서 StatusBar 아이콘 색상을
    // 설정하기 위해 AnnotatedRegion을 사용함.
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShoppingScreen(),
      ),
    );
  }
}

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.white,
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
                    transform: Matrix4.translationValues(-20.0, 0.0, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.only(left: 30),
                        minimumSize: const Size(70, 70),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RootTab()));
                      },
                      child: Image.asset(
                        "asset/logo_black.png",
                        width: 70,
                        height: 70,
                        //alignment: Alignment.bottomCenter,
                      ),
                    ))),
          ];
        },
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(child: FirstTabScreen()),
          ],
        ),
      ),
    );
  }
}

class FirstTabScreen extends ConsumerStatefulWidget {
  const FirstTabScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FirstTabScreen> createState() => _first();
}

//상의 Tab Screen
class _first extends ConsumerState<FirstTabScreen> {
  late Future<List<cloth>> futurecloth;

  @override
  void initState() {
    final storage = ref.read(secureStorageProvider);
    futurecloth = fetchcloth(storage);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: FutureBuilder<List<cloth>>(
        future: futurecloth,
        builder: (context, snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            newsListSliver = SliverPadding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (width / 2) / (120 + 200),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                      childCount: snapshot.data!.length,
                      (BuildContext context, int index) {
                    return ProductItem(
                      id: snapshot.data![index].id,
                      imageUrl: snapshot.data![index].s3_img_url,
                      productName: snapshot.data![index].goods_name,
                      brand: snapshot.data![index].brand_name,
                    );
                  }),
                ));
          } else {
            newsListSliver = const SliverToBoxAdapter(
              child: DefaultLoadingScreen(),
            );
          }

          return CustomScrollView(
            slivers: <Widget>[newsListSliver],
          );
        },
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  // final String favorite;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    // required this.favorite
  });
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

  final String id;
  final String imageUrl;
  final String productName;
  final String brand;

  @override
  ConsumerState<ProductItem> createState() => _productitem();
}

class FavoriteFormData {
  String? user_id;
  String? goods_id;

  FavoriteFormData({this.user_id, this.goods_id});

  Map<String, dynamic> toJson() => {'user_id': user_id, 'goods_id': goods_id};
}

class _productitem extends ConsumerState<ProductItem> {
  FavoriteFormData formData = FavoriteFormData();
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs(FlutterSecureStorage storage) async {
    var user = await storage.read(key: USER_ID);
    user = user.toString();
    prefs = await SharedPreferences.getInstance();

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
    List<String> data2 = [];

    if (resp.statusCode == 200) {
      Map body = resp.data;
      List<dynamic> data = body['data'];
      for (int i = 0; i < data.length; i++) {
        data2.add(data[i]['goods_info']['id'].toString());
      }

    } else {
      throw Exception('Failed to load album');
    }

    prefs.setStringList('likedToons' + user, data2);
    final likedToons = prefs.getStringList('likedToons' + user);

    if (likedToons != null) {
      //화면이 변경될 때
      setState(() {
        isLiked = likedToons.contains(widget.id);
      });
    } else {
      await prefs.setStringList('likedToons' + user, []);
    }
  }

  @override
  void initState() {
    final storage = ref.read(secureStorageProvider);
    initPrefs(storage);
    super.initState();
  }

  onFavorite() async {
    final storage = ref.read(secureStorageProvider);

    formData.user_id = await storage.read(key: USER_ID);
    formData.goods_id = widget.id.toString();

    final likedToons =
        prefs.getStringList('likedToons' + formData.user_id.toString());
    setState(() {
      isLiked = !isLiked;
      print("setstate");
    });
    if (likedToons != null) {
      if (isLiked) {
        likedToons.add(widget.id);
      } else {
        likedToons.remove(widget.id);
      }
      //핸드폰 저장소에 다시 List를 저장
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList(
          'likedToons' + formData.user_id.toString(), likedToons);
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
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 71, 71, 71),
                    ),
                  ),
                ),
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
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 8.0),
                      child: Text(widget.productName,
                          maxLines: 1,
                          textAlign: TextAlign.start,
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

// //카테고리별 탭 영역
// class TabBarDelegate extends SliverPersistentHeaderDelegate {
//   const TabBarDelegate();

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: TabBar(
//         tabs: [
//           Tab(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               color: Colors.white,
//               child: const Text(
//                 "상의",
//               ),
//             ),
//           ),
//           Tab(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               color: Colors.white,
//               child: const Text(
//                 "하의",
//               ),
//             ),
//           ),
//           Tab(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               color: Colors.white,
//               child: const Text(
//                 "blank",
//               ),
//             ),
//           ),
//         ],
//         indicatorWeight: 2,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         unselectedLabelColor: Colors.grey,
//         labelColor: Colors.black,
//         indicatorColor: Colors.black,
//         indicatorSize: TabBarIndicatorSize.label,
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 48;

//   @override
//   double get minExtent => 48;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// //카테고리 영역
// class CategoryBreadcrumbs extends SliverPersistentHeaderDelegate {
//   const CategoryBreadcrumbs();

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       height: 48,
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           const Text("의류", style: TextStyle(color: Colors.black)),
//           const SizedBox(width: 4),
//           const Text(">", style: TextStyle(color: Colors.black)),
//           const SizedBox(width: 4),
//           const Text("전체", style: TextStyle(color: Colors.black)),
//           const Spacer(),
//           TextButton(
//             onPressed: () {},
//             child: const Center(child: Text("전체보기")),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 48;

//   @override
//   double get minExtent => 48;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
