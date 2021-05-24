import 'package:flutter/material.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:tinycolor/tinycolor.dart';

typedef SkeletonBuilder = Widget Function(Color color);

class PulsatingSkeleton extends StatefulWidget {
  final ValueWidgetBuilder builder;
  final Widget child;
  final bool active;
  final Color color;
  final Color pulseColor;

  PulsatingSkeleton({
    @required this.builder,
    this.child,
    this.active = true,
    this.color = PLACEHOLDER_COLOR,
    this.pulseColor = PLACEHOLDER_PULSE_COLOR
  });

  @override
  State<StatefulWidget> createState() => _SkeletonBox();
}

class _SkeletonBox extends State<PulsatingSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  ValueNotifier<Color> _notifier;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    if (widget.active) _controller.repeat(reverse: true);

    _notifier = ValueNotifier(widget.color);

    _animation = ColorTween(
        begin: widget.color,
        end: widget.pulseColor
    )
        .animate(_controller)
      ..addListener(() {
        _notifier.value = _animation.value;
      });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      _controller.stop();
      return widget.child;
    }
    _controller.repeat(reverse: true);
    return ValueListenableBuilder(
        valueListenable: _notifier, builder: widget.builder);
  }
}