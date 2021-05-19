import 'package:flutter/material.dart';
import 'package:musicorum/components/content_header.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/components/two_layered_appbar.dart';
import 'package:musicorum/constants/colors.dart';

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  AnimatedAppBar(
      {this.notifier,
      @required this.name,
      this.secondary,
      @required this.image,
      this.appBar,
      this.actions,
      this.radius = 4});

  final AppBar appBar;
  final ValueNotifier<double> notifier;
  final String name;
  final String secondary;
  final ImageProvider image;
  final double radius;
  final List<Widget> actions;

  AppBar get appBarItem {
    if (appBar == null)
      return AppBar(
        elevation: 0.0,
      );
    else
      return appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (_, value, __) {
          final appBarVisibility =
              ContentHeader.getHeaderFractionFromOffset(context, value);
          return AppBar(
            elevation: 0.0,
            backgroundColor:
                APPBAR_COLOR.withAlpha((appBarVisibility * 255).toInt()),
            title: Opacity(
              opacity:
                  ContentHeader.getHeaderFractionFromOffset(context, value),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedImageProvider(
                    image,
                    radius: radius,
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(child: TwoLayeredAppBar(name, secondary))
                ],
              ),
            ),
            actions: actions,
          );
        });
  }
}
