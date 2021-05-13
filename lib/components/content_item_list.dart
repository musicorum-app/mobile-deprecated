import 'package:flutter/material.dart';
import 'package:musicorum/components/list_content.dart';

class ContentItemList extends StatelessWidget {
  final String name;
  final List<Widget> items;

  const ContentItemList({this.name, this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListContent(
          text: this.name,
          content: Column(
            children: items,
          ),
        )
      ],
    );
  }
}