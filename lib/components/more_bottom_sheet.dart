import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/states/login.dart';
import 'package:provider/provider.dart';

class MoreBottomSheet extends StatelessWidget {
  MoreBottomSheet({
    @required this.image,
    @required this.title,
    @required this.items,
    this.radius = 10.0,
  });

  final ImageProvider image;
  final double radius;
  final String title;
  final List<Widget> items;

  static openBottomSheet({
    @required BuildContext context,
    @required MoreBottomSheet item,
  }) {
    showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        context: context,
        builder: (context) => item);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            width: 60,
            height: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withAlpha(150)
            ),
          ),
          Row(
            children: [
              RoundedImageProvider(image, width: 80, height: 80, radius: radius,),
              SizedBox(width: 16.0,),
              Text(title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),)
            ],
          ),
          SizedBox(height: 10,),
          Divider(color: Colors.white.withAlpha(50),),
          ...items
        ],
      ),
    );
  }
}
