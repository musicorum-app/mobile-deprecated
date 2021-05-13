import 'package:flutter/material.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/profile.dart';
import 'package:musicorum/pages/profile_page.dart';

enum ListItemPlaceholderType { USER, TRACK, ARTIST }

class ListItemPlaceholder extends StatelessWidget {
  final ListItemPlaceholderType type;

  ListItemPlaceholder({this.type = ListItemPlaceholderType.TRACK});

  bool get isRoundedImage {
    return type == ListItemPlaceholderType.USER || type == ListItemPlaceholderType.ARTIST;
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: CONTENT_LIST_MARGIN_V),
      padding: EdgeInsets.symmetric(
          horizontal: CONTENT_LIST_PADDING_H, vertical: CONTENT_LIST_PADDING_V),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: isRoundedImage
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                color: PLACEHOLDER_COLOR),
            width: CONTENT_LIST_IMAGE_WIDTH + .0,
            height: CONTENT_LIST_IMAGE_WIDTH + .0,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(100)),
                    color: PLACEHOLDER_COLOR),
                width: 200,
                height: 18,
              ),
              (type == ListItemPlaceholderType.TRACK
                  ? Container(
                margin: EdgeInsets.only(top: 4.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(100)),
                          color: PLACEHOLDER_COLOR),
                      width: 96,
                      height: 13,
                    )
                  : Container())
            ],
          )
        ],
      ),
    );
  }
}
