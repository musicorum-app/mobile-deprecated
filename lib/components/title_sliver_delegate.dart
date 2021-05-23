import 'package:flutter/widgets.dart';
import 'package:musicorum/components/title.dart';

class PageTitleSliverDelegate extends SliverPersistentHeaderDelegate {
  PageTitleSliverDelegate({@required this.pageTitle});

  final PageTitle pageTitle;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => pageTitle;

  @override
  double get maxExtent => pageTitle.height;

  @override
  double get minExtent => pageTitle.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}