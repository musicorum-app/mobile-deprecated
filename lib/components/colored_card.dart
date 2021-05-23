import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:tinycolor/tinycolor.dart';

class ColoredCard extends StatelessWidget {
  ColoredCard(
      {this.mainColor,
      this.borderRadius = 4.0,
      this.onTap,
      this.child,
      this.padding});

  final Color mainColor;
  final double borderRadius;
  final Function onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;

  static LinearGradient createGradient (Color mainColor) {
    return LinearGradient(
        colors: mainColor != null
        ? [mainColor, mainColor.toTinyColor().lighten(18).color]
        : [GRADIENT_DEFAULT_1, GRADIENT_DEFAULT_2],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Ink(
        padding: padding,
        decoration: BoxDecoration(
            gradient: createGradient(mainColor),
            color: Color.fromRGBO(0, 0, 0, 0.8),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: child,
      ),
      onTap: onTap,
    );
  }
}
