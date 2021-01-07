import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';

class ViewMoreListItem extends StatelessWidget {
  const ViewMoreListItem({this.onTap, this.placeHolder = false});

  final Function onTap;
  final bool placeHolder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 18.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: SURFACE_SECONDARY_COLOR),
        child: Text('View more', style: TextStyle(
          color: placeHolder ? Colors.transparent : Colors.white
        ),),
      ),
    );
  }
}
