import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final String homeUri = 'https://kookmin-sw.github.io/capstone-2023-08/';

class AppHomePageScreen extends StatelessWidget {
  AppHomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '착붙 홈페이지',
      child: WebView(
        initialUrl: homeUri,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
