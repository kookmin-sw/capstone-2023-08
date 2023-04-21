import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('AI가'),
            Text('피팅 사진을 생성중입니다.'),
            Text('잠시만 기다려주세요'),
            Image.asset('asset/img/logo.png', height: MediaQuery.of(context).size.width * 0.6,),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
          ],
        ),
      ),
    );
  }
}
