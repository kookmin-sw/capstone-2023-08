import 'package:flutter/material.dart';
import 'package:client/screen/home_screen.dart';
import 'package:client/screen/login_screen.dart';
import 'package:client/screen/shoppingmall_screen.dart';


enum TabItem { home, shoppingMall, like, myPage }

const Map<TabItem, int> tabIdx = {
  TabItem.home: 0,
  TabItem.shoppingMall: 1,
  TabItem.like: 2,
  TabItem.myPage: 3,
};

Map<TabItem, Widget> tabScreen = {
  TabItem.home: HomeScreen(),
  TabItem.shoppingMall: HomeScreen(),
  TabItem.like: HomeScreen(),
  TabItem.myPage: LoginScreen(),
};