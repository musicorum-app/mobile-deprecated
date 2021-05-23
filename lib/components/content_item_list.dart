import 'package:flutter/material.dart';
import 'package:musicorum/components/list_content.dart';

class ContentItemList extends StatelessWidget {
  const ContentItemList({this.name, this.subtitle, this.items});

  final String name;
  final String subtitle;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListContent(
          subtitle: subtitle,
          text: this.name,
          content: Column(
            children: items,
          ),
        )
      ],
    );
  }
}
