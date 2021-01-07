import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.only(top: statusBarHeight + 20.0, bottom: 10.0),
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 42.0,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}