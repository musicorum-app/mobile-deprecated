import 'package:flutter/material.dart';
import 'package:musicorum/components/musicorum_page_route.dart';
import 'package:musicorum/components/two_layered_appbar.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';

class ExtendedItemsListPage extends StatelessWidget {
  ExtendedItemsListPage({this.title, this.subTitle, this.items});

  final String title;
  final String subTitle;
  final List<Widget> items;

  static openItemsPage(BuildContext context, String title, String subTitle,
      List<dynamic> items) {
    Navigator.push(
      context,
      createPageRoute(
        ExtendedItemsListPage(
          title: title,
          subTitle: subTitle,
          items: items.cast<Widget>(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TwoLayeredAppBar(title, subTitle),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
        children: items,
      ),
    );
  }
}
