import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:musicorum/components/charts_personal_view.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/title.dart';
import 'package:musicorum/constants/colors.dart';

class ChartsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChartsPageState();
  }
}

class ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: PageTitle('Charts'),
            ),
            SliverPersistentHeader(
              delegate: TabBarToolbarDelegate(
                  height: MediaQuery.of(context).padding.top),
              pinned: true,
            ),
            SliverPersistentHeader(
                pinned: true,
                delegate: TabBarDelegate(
                  tabBar: TabBar(
                    indicatorColor: MUSICORUM_COLOR,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.person_rounded),
                        text: 'Personal',
                      ),
                      Tab(
                        icon: Icon(Icons.public_rounded),
                        text: 'Global',
                      ),
                    ],
                  ),
                ))
          ],
          body: TabBarView(
            // physics: BouncingScrollPhysics(),
            children: [
              ChartsPersonalView(),
              Text('geo')
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  TabBarDelegate({@required this.tabBar});

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class TabBarToolbarDelegate extends SliverPersistentHeaderDelegate {
  TabBarToolbarDelegate({@required this.height, this.color});

  final double height;
  final Color color;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: color != null ? color : Theme.of(context).appBarTheme.backgroundColor,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
