import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musicorum/api/models/tag.dart';
import 'package:musicorum/pages/tag_page.dart';
import 'package:tinycolor/tinycolor.dart';

List<double> RANDOM_SIZES = [
  TagsFragment.getRandom(),
  TagsFragment.getRandom(),
  TagsFragment.getRandom(),
  TagsFragment.getRandom(),
  TagsFragment.getRandom(),
  TagsFragment.getRandom()
];

const ITEM_MARGIN = 5.0;
const ITEM_PADDING = 14.0;

class TagsFragment extends StatelessWidget {
  const TagsFragment(this.tags, this._color);

  final List<Tag> tags;
  final Color _color;

  bool get isLoaded {
    return tags != null;
  }

  static getRandom() {
    return Random().nextInt(55) + 35.0;
  }

  Color get color {
    return _color != null
        ? _color.toTinyColor().brighten(30).color
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    int length = isLoaded ? tags.length : 6;

    return Container(
      height: 28.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: length,
        itemBuilder: (context, index) {
          var leftMargin = index == 0 ? 0.0 : ITEM_MARGIN;
          var rightMargin = index == (length - 1) ? 0.0 : ITEM_MARGIN;
          if (!isLoaded) {
            return Container(
              margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(100)),
                  color: Colors.white.withAlpha(30)),
              width: RANDOM_SIZES[index],
            );
          }

          return Container(
            margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
            child: InkWell(
              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
              splashColor: color,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ITEM_PADDING),
                decoration: BoxDecoration(
                    border: Border.all(color: color),
                    borderRadius: new BorderRadius.all(Radius.circular(100)),
                    color: color.withAlpha(30)),
                child: Center(
                  child: Text(tags[index].name),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagPage(tags[index]),
                    ));
              },
            ),
          );
        },
      ),
    );
  }
}
