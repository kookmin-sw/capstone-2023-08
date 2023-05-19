import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';

// merge할때 귀찮은 작업들을 피하기 위해 그냥 삭제
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('홈'),));
  }
}