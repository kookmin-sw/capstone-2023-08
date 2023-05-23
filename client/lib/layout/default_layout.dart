import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? appBarColor;
  final Color? appBarFontColor;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.appBarColor,
    this.appBarFontColor,
    this.title,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: renderAppBar(),
        backgroundColor: backgroundColor?? Colors.white,
        body: child,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: appBarColor?? Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title!,
          style: TextStyle(
            color: appBarFontColor?? Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: appBarFontColor?? Colors.black,
      );
    }
  }
}