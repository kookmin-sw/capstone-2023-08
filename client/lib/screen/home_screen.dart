import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'clotheslist_screen.dart';

final imageList = [
  Image.asset('assets/image1.jpg', fit: BoxFit.cover),
  Image.asset('assets/image2.png', fit: BoxFit.cover),
  Image.asset('assets/image3.png', fit: BoxFit.cover),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // Widget build(BuildContext context) {
  //   return ListView(
  //     children: <Widget>[
  //       _buildTop(),
  //      // _buildMiddle(),
  //     ],
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment(0, -0.7),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Fit on, ',
                    style: TextStyle(fontSize: 35, color: Colors.grey)),
                TextSpan(
                    text: 'Fit me!',
                    style: TextStyle(fontSize: 35, color: Colors.black)),
              ])),
        ),
        Container(
            alignment: Alignment(0, -0.4),
            child: Text(
                "원하는 옷을 원하는 장소에서 입어보세요!\n무신사 TOP 90을 입거나,\n직접 옷을 선택해서 입어볼 수 있습니다.")),
        Container(
          alignment: Alignment(0, 0.2),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              // onPageChanged: (index, reason) {
              //   setState(() {
              //     _currentPages = index;
              //     _currentKeyword = keywords[_currentPage];
              //   });
              // },
              //enableInfiniteScroll: true,
            ),
            items: imageList.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    //Alignment(0, 0),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: image,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        //CarouselPage(),
        Container(
          alignment: Alignment(-0.5, 0.7),
          child: ElevatedButton(
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'MUSINSA\n',
                  ),
                  TextSpan(
                    text: '옷 입어보기',
                  ),
                ])),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ShoppingApp()));
            }, // 옷 리스트 페이지(closelist) 이동
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 50),
              primary: Colors.black, // Background color
              alignment: Alignment.center,
            ),
          ),
        ),
        Container(
          alignment: Alignment(0.5, 0.7),
          child: ElevatedButton(
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: '갤러리에서\n',
                  ),
                  TextSpan(
                    text: '옷 고르기',
                  ),
                ])),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 50),
              primary: Colors.black, // Background color
            ),
          ),
          // FloatingActionButton(
          //   backgroundColor: Colors.black,
          //   onPressed: () {},
          //   child: Icon(Icons.camera_alt_rounded),
          // ),
        )
      ],
    ));
  }

  // Widget _buildMiddle() {
  //   return CarouselSlider(
  //     options: CarouselOptions(autoPlay: true),
  //     items: imageList.map((image) {
  //       return Builder(
  //         builder: (BuildContext context) {
  //           return Container(
  //             //Alignment(0, 0),
  //             //width: MediaQuery.of(context).size.width,
  //             //margin: EdgeInsets.symmetric(horizontal: 5.0),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(10.0),
  //               child: image,
  //             ),
  //           );
  //         },
  //       );
  //     }).toList(),
  //   );
  // }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: RichText(
//         text: TextSpan(children: [
//       TextSpan(
//           text: 'Fit on, ', style: TextStyle(fontSize: 35, color: Colors.grey)),
//       TextSpan(
//           text: 'Fit me!', style: TextStyle(fontSize: 35, color: Colors.black)),
//     ])),
//     );
//   }
// }
