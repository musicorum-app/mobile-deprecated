import 'package:flutter/cupertino.dart';
import 'package:musicorum/constants/colors.dart';

Route createPageRoute(Widget newPage) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final newScaleTween = Tween(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut));

        final newFadeTween = Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut));

        final currentFadeTween = Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Interval(0.0, 0.5, curve: Curves.easeOut)));

        return Container(
            color: SURFACE_COLOR
                .withOpacity(animation.drive(currentFadeTween).value),
            child: FadeTransition(
              opacity: animation.drive(newFadeTween),
              child: ScaleTransition(
                scale: animation.drive(newScaleTween),
                child: child,
              ),
            ));
      },
    );
