import 'package:flutter/material.dart';
import 'tab_item.dart';

class BottomNavigation extends StatelessWidget {
  // navbarItems -> icon과 title 지정
  List<BottomNavigationBarItem> navbarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '홈',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag_outlined),
      label: '쇼핑몰',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: '찜',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: '프로필',
    ),
  ];

  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.home),
        _buildItem(TabItem.shoppingMall),
        _buildItem(TabItem.like),
        _buildItem(TabItem.myPage),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
      selectedItemColor: Colors.amber,
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return navbarItems[tabIdx[tabItem]!];
  }
}