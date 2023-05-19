// import 'dart:html';

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
import 'shoppingmall_screen.dart';
import '../main.dart';

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
    'http://35.84.85.252:8000/goods/cloth-list',
  );

  if (resp.statusCode == 200) {
    //print(resp.data);
    // final body = json.decode(resp.data);
    // List<dynamic> data = body['data'];
    Map body = resp.data;
    List<dynamic> data = body['data'];
    // var allInfo = data.map((item) => cloth.fromJson(item)).toList();
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

  // @override
  // void initState() {
  //   super.initState();
  //   futurecloth = fetchcloth();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // iOS에서 StatusBar의 색상을 정해주기위해 설정
    // TabBar 등을 사용하려면 Scaffold 혹은 Meterial로 감싸줘야함.
    //fetchcloth();
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
                          child: Image.asset(
                            "asset/logo_black.png",
                            width: 70,
                            height: 70,
                            //alignment: Alignment.bottomCenter,
                          ),
                          style: ElevatedButton.styleFrom(
                            //alignment: Alignment.bottomLeft,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.only(left: 30),
                            minimumSize: Size(70, 70),
                            elevation: 0,
                          ),
                          onPressed: () {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RootTab()));
                          },
                        ))),
                // 변경사항
                // SliverOverlapAbsorber(
                //   handle:
                //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                //   sliver: const SliverPersistentHeader(
                //       pinned: true, delegate: TabBarDelegate()),
                // ),
              ];
            },
            body: Column(children: [
              SizedBox(height: 30,),
              Expanded(child: FirstTabScreen()),
            ],),
            // Column(
            //   children: [
            //     // SizedBox(height: 48),
            //     Expanded(
            //       child: TabBarView(
            //         children: [
            //           const FirstTabScreen(),
            //           Container(
            //             color: Colors.redAccent,
            //           ),
            //           Container(
            //             color: Colors.blue,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ),
      // SafeArea(
      //   child: DefaultTabController(
      //     length: 3, //개수 변경
      //     child: NestedScrollView(
      //       headerSliverBuilder: (context, innerBoxIsScrolled) {
      //         return [
      //           SliverAppBar(
      //               pinned: false,
      //               floating: true,
      //               forceElevated: innerBoxIsScrolled,
      //               toolbarHeight: 60,
      //               elevation: 0,
      //               backgroundColor: Colors.white,
      //               automaticallyImplyLeading: true,
      //               centerTitle: false,
      //               title: Transform(
      //                   transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
      //                   child: ElevatedButton(
      //                     child: Image.asset(
      //                       "asset/logo_black.png",
      //                       width: 70,
      //                       height: 70,
      //                       //alignment: Alignment.bottomCenter,
      //                     ),
      //                     style: ElevatedButton.styleFrom(
      //                       //alignment: Alignment.bottomLeft,
      //                       backgroundColor: Colors.white,
      //                       padding: EdgeInsets.only(left: 30),
      //                       minimumSize: Size(70, 70),
      //                       elevation: 0,
      //                     ),
      //                     onPressed: () {
      //                       //Navigator.pop(context);
      //                       Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) => RootTab()));
      //                     },
      //                   ))),
      //           // 변경사항
      //           // SliverOverlapAbsorber(
      //           //   handle:
      //           //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      //           //   sliver: const SliverPersistentHeader(
      //           //       pinned: true, delegate: TabBarDelegate()),
      //           // ),
      //         ];
      //       },
      //       body: Column(
      //         children: [
      //           SizedBox(height: 20,),
      //           Expanded(
      //             child: FirstTabScreen()
      //           ),
      //         ],
      //       )
      //       // Column(
      //       //   children: [
      //       //     // SizedBox(height: 48),
      //       //     Expanded(
      //       //       child: TabBarView(
      //       //         children: [
      //       //           const FirstTabScreen(),
      //       //           Container(
      //       //             color: Colors.redAccent,
      //       //           ),
      //       //           Container(
      //       //             color: Colors.blue,
      //       //           ),
      //       //         ],
      //       //       ),
      //       //     ),
      //       //   ],
      //       // ),
      //     ),
      //   ),
      // ),
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
  //const FirstTabScreen({Key? key}) : super(key: key);
  late Future<List<cloth>> futurecloth;
  // late SharedPreferences prefs;

  // Future initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   final likedToons = prefs.getStringList('likedToons');
  //   if (likedToons != null) {
  //     if (likedToons.contains(widget.id) == true) {
  //       //화면이 변경될 때
  //       setState(() {
  //         isLiked = true;
  //       });
  //     }
  //   } else {
  //     await prefs.setStringList('likedToons', []);
  //   }
  // }

  @override
  void initState() {
    final storage = ref.read(secureStorageProvider);
    futurecloth = fetchcloth(storage);
    //initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<cloth>>(
      future: futurecloth,
      builder: (context, snapshot) {
        Widget newsListSliver;
        if (snapshot.hasData) {
          newsListSliver = SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
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
          newsListSliver = SliverToBoxAdapter(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
          slivers: <Widget>[
            // const SliverPersistentHeader(
            //     pinned: true, delegate: CategoryBreadcrumbs()),
            
            newsListSliver
          ],
        );
      },
    );
  }

//   @override
//   Widget build(BuildContext context) {
// // 변경사항
//     return Column(
//       children: [
//         const SizedBox(height: 48),
//         Expanded(
//           child: CustomScrollView(
//             slivers: [
//               // SliverToBoxAdapter(
//               //   child: Container(
//               //     height: 400,
//               //     color: Colors.grey,
//               //   ),
//               // ),

//               const SliverPersistentHeader(
//                   pinned: true, delegate: CategoryBreadcrumbs()),

//               // SliverList(
//               //     delegate: SliverChildBuilderDelegate(
//               //         (context, index) => Container(
//               //               height: 40,
//               //               // 보는 재미를 위해 인덱스에 아무 숫자나 곱한 뒤 255로
//               //               // 나눠 다른 색이 보이도록 함.
//               //               color: Color.fromRGBO((index * 45) % 255,
//               //                   (index * 70) % 255, (index * 25), 1.0),
//               //             ),
//               //         childCount: 40)
//               //         ),

//               // SliverGrid(
//               //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               //     maxCrossAxisExtent: 200.0,
//               //     mainAxisSpacing: 10.0,
//               //     crossAxisSpacing: 10.0,
//               //     childAspectRatio: 4.0,
//               //   ),
//               //   delegate: SliverChildBuilderDelegate(
//               //     (BuildContext context, int index) {
//               //       return Container(
//               //         alignment: Alignment.center,
//               //         color: Colors.teal[100 * (index % 9)],
//               //         child: Text(
//               //           'Grid Item ${index + 1}',
//               //           style: TextStyle(fontSize: 20),
//               //         ),
//               //       );
//               //     },
//               //     childCount: 10,
//               //   ),
//               // ),
//               SliverList(
//                 delegate: SliverChildListDelegate([
//                   Container(
//                       child: FutureBuilder(
//                           future: futurecloth,
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               int index = snapshot.data!.length;
//                               return ProductItem(
//                                 imageUrl: snapshot.data![index].s3_img_url,
//                                 productName: snapshot.data![index].goods_name,
//                                 price: '\$${(index + 1) * 10}',
//                               );
//                             } else if (snapshot.hasError) {
//                               return Text('${snapshot.hasError}');
//                             }
//                             return const CircularProgressIndicator();
//                           }))
//                 ]),
//               ),

//               // FutureBuilder<List<cloth>>(
//               //     future: futurecloth,
//               //     builder: (context, snapshot){
//               //       if (snapshot.hasData) {
//               //         return ListView.builder(
//               //             itemCount: snapshot.data!.length,
//               //             itemBuilder: (context, index) {
//               //               cloth goods = snapshot.data![index];
//               //               return Card(
//               //                 child: ListTile(
//               //                   title: Text(goods.id.toString()),
//               //                 ),
//               //               );
//               //             });
//               //       } else if (snapshot.hasError) {
//               //         return Text('${snapshot.hasError}');
//               //       }
//               //       return const CircularProgressIndicator();
//               //     }
//               // ),
//               SliverGrid(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7,
//                   mainAxisSpacing: 16.0,
//                   crossAxisSpacing: 16.0,
//                 ),
//                 delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) {
//                     return ProductItem(
//                       imageUrl: 'assets/clothes/product-image.jpg',
//                       productName: 'Product Name $index',
//                       price: '\$${(index + 1) * 10}',
//                     );
//                   },
//                   childCount: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
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

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
        //화면이 변경될 때
        setState(() {
          isLiked = likedToons.contains(widget.id);
        });
    }
    else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    initPrefs();
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

    final likedToons = prefs.getStringList('likedToons');
    setState(() {
      isLiked = !isLiked;
      print("setstate");
    });
    if (likedToons != null) {
      if (isLiked) {
        likedToons.add(widget.id);
        // likedToons.remove(widget.id);
      } else {
        likedToons.remove(widget.id);
        // likedToons.add(widget.id);
      }
      //핸드폰 저장소에 다시 List를 저장
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList('likedToons', likedToons);
    }

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
  // final String id;
  // final String imageUrl;
  // final String productName;
  // final String brand;
  // final String favorite;

  // FavoriteFormData formData = FavoriteFormData();
  // bool isLiked = false;

  // onFavorite() async {
  //   //찜 API 연결
  //   formData.user_id = "test";
  //   formData.goods_id = id.toString();
  //   setState((){
  //     isLiked = !isLiked;
  //   });
  //   var result = await http.post(
  //     Uri.parse('http://35.84.85.252:8000/goods/dips/add'),
  //     body: json.encode(formData.toJson()),
  //   );
  //   if (result.statusCode != 200) {
  //     print("찜 추가 실패");
  //   }
  // }

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
            initPrefs();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.circular(10.0),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 5,
            //     offset: Offset(0, 3),
            //   ),
            // ],
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 6.5,
              // ),
              // Stack(
              //   children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
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
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    widget.brand,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Color.fromARGB(255, 71, 71, 71),
                    ),
                  ),
                ),
                //SizedBox(width: 0),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Icon(
                      isLiked
                          ? Icons.favorite
                          : Icons.favorite_outline_outlined,
                      size: 20,
                      color: Color.fromARGB(255, 255, 174, 53),
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: onFavorite,
                //   padding: EdgeInsets.zero,
                //   //alignment: Alignment.centerLeft,
                //   color: Color.fromARGB(255, 255, 174, 53),
                //   icon: Icon(isLiked
                //       ? Icons.favorite
                //       : Icons.favorite_outline_outlined),
                //   iconSize: 20.0,
                // ),
              ]),
              // SizedBox(height: 3.0),
              Row(children: [
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 160,
                      child: Flexible(
                          child: RichText(
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                            text: widget.productName,
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      )),
                    )),
              ]),
            ],
          ),
        ));
  }
}

//카테고리별 탭 영역
class TabBarDelegate extends SliverPersistentHeaderDelegate {
  const TabBarDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: const Text(
                "상의",
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: const Text(
                "하의",
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: const Text(
                "blank",
              ),
            ),
          ),
        ],
        indicatorWeight: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

//카테고리 영역
class CategoryBreadcrumbs extends SliverPersistentHeaderDelegate {
  const CategoryBreadcrumbs();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text("의류", style: TextStyle(color: Colors.black)),
          const SizedBox(width: 4),
          const Text(">", style: TextStyle(color: Colors.black)),
          const SizedBox(width: 4),
          const Text("전체", style: TextStyle(color: Colors.black)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Center(child: Text("전체보기")),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
