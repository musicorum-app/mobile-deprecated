import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage(this.url, {this.radius, this.height, this.width});

  final String url;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.radius),
      child: Image.network(
        this.url,
        height: this.height,
        width: this.width,
          fit: BoxFit.contain
      ),
    );
  }
}

class RoundedImageProvider extends StatelessWidget {
  const RoundedImageProvider(this.image, {this.radius, this.height, this.width});

  final ImageProvider image;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.radius),
      child: Image(image: this.image,
      width: this.width,
      height: this.height,
      fit: BoxFit.contain,),
    );
  }
}