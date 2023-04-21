import 'dart:async';
import 'dart:io';

import 'package:client/screen/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:client/constant/page_name.dart';

class LoadingSuccessScreen extends StatefulWidget {
  final File imageFile;

  const LoadingSuccessScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<LoadingSuccessScreen> createState() => _LoadingSuccessScreenState();
}

class _LoadingSuccessScreenState extends State<LoadingSuccessScreen> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ResultScreen(
          imageFile: widget.imageFile,
        ),
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('생성 완료!'),
      ),
    );
  }
}
