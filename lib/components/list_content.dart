import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';

class ListContent extends StatelessWidget {
  const ListContent({this.text, this.subtitle, this.content});

  final String text;
  final String subtitle;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 28.0,
        ),
        Text(
          this.text,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        subtitle != null ? Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.0,
            color: SURFACE_SECONDARY_TEXT_COLOR
          ),
        ) : Container(),
        SizedBox(
          height: 6.0,
        ),
        this.content
      ],
    );
  }
}
