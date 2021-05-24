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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value != null ? NumberFormat.compact().format(value) : '-',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
          ),
          Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
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
