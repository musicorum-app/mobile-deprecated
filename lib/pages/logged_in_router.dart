import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/navigation/destination.dart';
import 'package:musicorum/pages/account.dart';
import 'package:musicorum/pages/charts.dart';
import 'package:musicorum/pages/discover.dart';
import 'package:musicorum/pages/home.dart';
import 'package:musicorum/pages/scrobbling.dart';
import 'package:musicorum/states/login.dart';
import 'package:provider/provider.dart';
import 'package:custom_navigator/custom_navigation.dart';

class LoggedInRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoggedInRouterState();
  }
}

class LoggedInRouterState extends State<LoggedInRouter> {
  int _page = 0;
  List<Widget> pages;

  final PageController pageController = PageController();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    pages = [
      HomePage(),
      DiscoverPage(),
      ScrobblingPage(),
      ChartsPage(),
      AccountPage()
    ];

    onChangePage();

    super.initState();
  }

  final navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  onChangePage () {
    Provider.of<AuthState>(context, listen: false).selectedBottomItem = page;
  }

  int get page => _page;

  set page(int p) {
    _page = p;
    onChangePage();
  }

  Widget _buildPageOffstage(GlobalKey<NavigatorState> key, int index) {
    return Offstage(
      offstage: page != index,
      child: CustomNavigator(
        navigatorKey: key,
        home: pages[index],
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildPageOffstage(navigatorKeys[0], 0),
            _buildPageOffstage(navigatorKeys[1], 1),
            _buildPageOffstage(navigatorKeys[2], 2),
            _buildPageOffstage(navigatorKeys[3], 3),
            _buildPageOffstage(navigatorKeys[4], 4),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              child: BottomNavigationBar(
                  backgroundColor: SURFACE_SECONDARY_COLOR,
                  selectedItemColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: page,
                  showUnselectedLabels: false,
                  showSelectedLabels: true,
                  onTap: (int index) {
                    if (index == page) {
                      navigatorKeys[index].currentState.popUntil((
                          route) => route.isFirst);
                      return;
                    }
                    setState(() {
                      page = index;
                    });
                  },
                  items: destinations
                      .map((Destination dest) =>
                      BottomNavigationBarItem(
                          icon: Icon(dest.icon), label: dest.title))
                      .toList()),
              // margin: EdgeInsets.only(top: kBottomNavigationBarHeight),
            ),
            // Container(
            //   width: double.infinity,
            //   height: kBottomNavigationBarHeight,
            //   color: Colors.blue,
            // ),
          ],
        ),
      ),
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await navigatorKeys[_page].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (page != 0) {
            // select 'main' tab
            setState(() {
              page = 0;
            });
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
    );
  }
}
