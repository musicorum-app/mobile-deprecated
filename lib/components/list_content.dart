import 'package:flutter/material.dart';

class ListContent extends StatelessWidget {
  const ListContent({this.text, this.content});

  final String text;
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
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(
          height: 6.0,
        ),
        this.content
      ],
    );
  }
}
