import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:intl/intl.dart';

class ContentStat extends StatelessWidget {
  final String text;
  final int value;

  const ContentStat({this.text, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormat.compact().format(value != null ? value : 0),
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
          ),
          Text(
            text.toUpperCase(),
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: SURFACE_SECONDARY_TEXT_COLOR),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 28.0),
    );
  }
}
