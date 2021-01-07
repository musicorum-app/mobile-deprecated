import 'package:flutter/material.dart';
import 'package:musicorum/api/models/wiki.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/components/two_layered_appbar.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:url_launcher/url_launcher.dart';

class WikiPage extends StatelessWidget {
  const WikiPage(this.wiki, this.predominantColor, this.title, this.subTitle);

  final String title;
  final String subTitle;
  final Wiki wiki;
  final Color predominantColor;

  _openWiki () async {
    if (await canLaunch(wiki.url)) {
      await launch(wiki.url);
    } else {
      throw 'Could not launch ${wiki.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TwoLayeredAppBar(subTitle, title),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text('Published ${wiki.published}', style: TextStyle(
            color: SURFACE_SECONDARY_TEXT_COLOR
          ),),
          SizedBox(
            height: 10.0,
          ),
          Text(wiki.contentFiltered),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: _openWiki,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: Ink(
                  padding:
                  EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.white.withOpacity(.2)),
                  child: Text('Read more on Last.fm'),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            wiki.disclaimer,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }
}