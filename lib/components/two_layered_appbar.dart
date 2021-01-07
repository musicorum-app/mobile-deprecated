import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';

class TwoLayeredAppBar extends StatelessWidget {
  const TwoLayeredAppBar(this.title, this.subTitle);

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
        ),
        (subTitle != null
            ? Text(
                subTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.0, color: SURFACE_SECONDARY_TEXT_COLOR),
              )
            : Container())
      ],
    );
  }
}
