import 'package:flutter/material.dart';

// bottom navigation을 위해 필요한 위젯, 상수
import 'bottom_navigator.dart';
import 'tab_navigator.dart';
import 'tab_item.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  var _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.shoppingMall: GlobalKey<NavigatorState>(),
    TabItem.like: GlobalKey<NavigatorState>(),
    TabItem.myPage: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      /// 네비게이션 탭을 누르면, 해당 네비의 첫 스크린으로 이동!
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    // (offstage == false) -> 트리에서 완전히 제거된다.
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          // 메인 화면이 아닌 경우
          if (_currentTab != TabItem.home) {
            // 메인 화면으로 이동
            _selectTab(TabItem.home);
            // 앱 종료 방지
            return false;
          }
        }

        /// 네비게이션 바의 첫번째 스크린인 경우, 앱 종료
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                _buildOffstageNavigator(TabItem.home),
                _buildOffstageNavigator(TabItem.shoppingMall),
                _buildOffstageNavigator(TabItem.like),
                _buildOffstageNavigator(TabItem.myPage),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }
}
