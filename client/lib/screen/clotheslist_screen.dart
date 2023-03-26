import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'shoppingmall_screen.dart';
import '../main.dart';

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
                    title: RichText(
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
                        ])),
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

//상의 Tab Screen
class FirstTabScreen extends StatelessWidget {
  const FirstTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// 변경사항
    return Column(
      children: [
        const SizedBox(height: 48),
        Expanded(
          child: CustomScrollView(
            slivers: [
              // SliverToBoxAdapter(
              //   child: Container(
              //     height: 400,
              //     color: Colors.grey,
              //   ),
              // ),

              const SliverPersistentHeader(
                  pinned: true, delegate: CategoryBreadcrumbs()),

              // SliverList(
              //     delegate: SliverChildBuilderDelegate(
              //         (context, index) => Container(
              //               height: 40,
              //               // 보는 재미를 위해 인덱스에 아무 숫자나 곱한 뒤 255로
              //               // 나눠 다른 색이 보이도록 함.
              //               color: Color.fromRGBO((index * 45) % 255,
              //                   (index * 70) % 255, (index * 25), 1.0),
              //             ),
              //         childCount: 40)
              //         ),

              // SliverGrid(
              //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //     maxCrossAxisExtent: 200.0,
              //     mainAxisSpacing: 10.0,
              //     crossAxisSpacing: 10.0,
              //     childAspectRatio: 4.0,
              //   ),
              //   delegate: SliverChildBuilderDelegate(
              //     (BuildContext context, int index) {
              //       return Container(
              //         alignment: Alignment.center,
              //         color: Colors.teal[100 * (index % 9)],
              //         child: Text(
              //           'Grid Item ${index + 1}',
              //           style: TextStyle(fontSize: 20),
              //         ),
              //       );
              //     },
              //     childCount: 10,
              //   ),
              // ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ProductItem(
                      imageUrl: 'assets/clothes/product-image.jpg',
                      productName: 'Product Name $index',
                      price: '\$${(index + 1) * 10}',
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ],
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
  final String imageUrl;
  final String productName;
  final String price;

  const ProductItem({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Image.asset(
            imageUrl,
            height: 150.0,
            width: 150.0,
          ),
          SizedBox(height: 10.0),
          Text(
            productName,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            price,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
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