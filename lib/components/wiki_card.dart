import 'package:flutter/material.dart';
import 'package:musicorum/api/models/wiki.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/components/musicorum_page_route.dart';
import 'package:musicorum/pages/wiki_page.dart';

class WikiCard extends StatelessWidget {
  const WikiCard(this.wiki, {this.predominantColor, this.title = 'BIOGRAPHY', this.subTitle});

  final String title;
  final String subTitle;
  final Wiki wiki;
  final Color predominantColor;

  bool get isWikiNull {
    return wiki.summary == null || wiki.summaryFiltered == '';
  }

  String get wikiText {
    if (!isWikiNull) {
      return wiki.summaryFiltered + (wiki.summaryFiltered == wiki.contentFiltered ? '' : '...');
    } else {
      return 'No wiki found.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredCard(
      onTap: () {
        if (isWikiNull) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('There\'s no wiki about this.'),
        ));
        else Navigator.push(
            context,
            createPageRoute(
                WikiPage(wiki, predominantColor, title, subTitle)));
      },
      mainColor: predominantColor,
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(.8)),
            ),
            SizedBox(
              height: 6.0,
            ),
            Text(wiki != null ? wikiText : 'Loading...'),
            SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Ink(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.white.withOpacity(.2)),
                    child: Text('Read more'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
