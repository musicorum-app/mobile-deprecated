import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {this.actions, this.margin = true});

  final String text;
  final List<Widget> actions;
  final bool margin;

  double get height => 70;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      margin: margin ? EdgeInsets.only(top: statusBarHeight, bottom: 10.0) : EdgeInsets.only(),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.0),
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
            // height: 30.0,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.only(top: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions != null ? actions : [Container()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
