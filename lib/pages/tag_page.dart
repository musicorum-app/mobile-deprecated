import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicorum/api/models/tag.dart';
import 'package:musicorum/constants/colors.dart';

class TagPage extends StatefulWidget {
  TagPage(this.tag);

  final Tag tag;

  @override
  State<StatefulWidget> createState() => TagPageState();
}

class TagPageState extends State<TagPage> {
  Tag tag;

  Future<void> _refresh() async {
    return null;
  }

  _buildHeader () {
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      SURFACE_COLOR.withAlpha(90),
                      SURFACE_COLOR
                    ],
                    stops: [0.56, 1],
                    begin: FractionalOffset.topCenter,
                    end: AlignmentDirectional.bottomCenter,
                  )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                _buildHeader(),
                Text(widget.tag.name)
              ],
            ),
          )
      ),
    );
  }
}