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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: pages,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: SURFACE_SECONDARY_COLOR,
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        onTap: (int index) {
          pageController.jumpToPage(index);
        },
        items: destinations
          .map((Destination dest) => BottomNavigationBarItem(icon: Icon(dest.icon), label: dest.title))
          .toList()
      ),
    );
  }
}
