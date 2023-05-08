import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'shoppingmall_screen.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'login_screen.dart';
import 'test_detail_screen.dart';

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

Future<List<cloth>> fetchcloth() async {
  final response =
      await http.get(Uri.parse('http://35.84.85.252:8000/goods/cloth-list'));

  if (response.statusCode == 200) {
    Map body = json.decode(response.body);
    List<dynamic> data = body['data'];
    var allInfo = data.map((item) => cloth.fromJson(item)).toList();
    return allInfo;
  } else {
    throw Exception('Failed to load album');
  }
}

//찜 버튼
// class FavoriteFormData {
//   String? user_id;
//   String? goods_id;

//   FavoriteFormData({this.user_id, this.goods_id});

//   Map<String, dynamic> toJson() => {'user_id': user_id, 'goods_id': goods_id};
// }

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({Key? key}) : super(key: key);

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
        home: ShoppingScreen(),
      ),
    );
  }
}

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({Key? key}) : super(key: key);
  

  // @override
  // void initState() {
  //   super.initState();
  //   futurecloth = fetchcloth();
  // }

  @override
  Widget build(BuildContext context) {
    // iOS에서 StatusBar의 색상을 정해주기위해 설정
    // TabBar 등을 사용하려면 Scaffold 혹은 Meterial로 감싸줘야함.
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: DefaultTabController(
          length: 3, //개수 변경
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    pinned: false,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    toolbarHeight: 48,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
	                    //textBaseline: TextBaseline.alphabetic,
                      children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Fit on, ',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.grey)),
                          TextSpan(
                              text: 'Fit me!',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black)),
                        ]))),
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
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                        },
                    ),
                  )
                    ],),
                    actions: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          //tooltip: 'Add new entry',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                        ),
                      ),
                    ]),
                // 변경사항
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: const SliverPersistentHeader(
                      pinned: true, delegate: TabBarDelegate()),
                ),
              ];
            },
            body: Column(
              children: [
                // SizedBox(height: 48),
                Expanded(
                  child: TabBarView(
                    children: [
                      const FirstTabScreen(),
                      Container(
                        color: Colors.redAccent,
                      ),
                      Container(
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirstTabScreen extends StatefulWidget {
  const FirstTabScreen({Key? key}) : super(key: key);

  @override
  _first createState() => _first();
}

//상의 Tab Screen
class _first extends State<FirstTabScreen> {
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
              return ProductItem(
                id: snapshot.data![index].id,
                imageUrl: snapshot.data![index].s3_img_url,
                productName: snapshot.data![index].goods_name,
                brand: snapshot.data![index].brand_name,
              );
            }),
          );
        } else {
          newsListSliver = SliverToBoxAdapter(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
          slivers: <Widget>[
            const SliverPersistentHeader(
                pinned: true, delegate: CategoryBreadcrumbs()),
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

class ProductItem extends StatelessWidget {
  final String id;
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
              context, MaterialPageRoute(builder: (context) => DetailScreen(item:ProductItem(id:id, imageUrl:imageUrl, productName:productName,brand: brand))));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
            children: [
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 150.0,
                    width: 150.0,
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
                ],
              ),
//               Image.network(
//                 imageUrl,
//                 height: 150.0,
//                 width: 150.0,
//               ),
//               SizedBox(height: 10.0),
// // 찜 버튼
//               IconButton(
//                 alignment: Alignment.centerLeft,
//                 icon: Icon(Icons.favorite_border
//                     //isFavorite ? Icons.favorite : Icons.favorite_border,
//                     //color: isFavorite ? Colors.red : null,
//                     ),
//                 iconSize: 10.0,
//                 onPressed: () {},
//               ),
              //SizedBox(height: 10.0),
              Text(
                productName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                brand,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
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
          // Tab(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     color: Colors.white,
          //     child: const Text(
          //       "하의",
          //     ),
          //   ),
          // ),
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

// class ClothesPage extends StatelessWidget {
//   const ClothesPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: /*탭바의 수 만큼 */,
//       child: CustomScrollView(
//         slivers: [
//           SliverAppBar(),
//           SliverPersistentHeader(delegate: /*탭바*/ ),
//           SliverFillRemaining(
//             // 탭바 뷰 내부에는 스크롤이 되는 위젯이 들어옴.
//             hasScrollBody: true,
//             child: TabBarView(),
//           )
//         ],
//       ),
//     );
//   }
// }

// return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Screen A page"),
//       // ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text("Go to Screen A Page"),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );