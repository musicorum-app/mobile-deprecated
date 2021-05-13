import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {this.actions});

  final String text;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.only(top: statusBarHeight, bottom: 10.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions != null ? actions : [Container()],
            ),
          ),
        ],
      ),
    );
  }
}
