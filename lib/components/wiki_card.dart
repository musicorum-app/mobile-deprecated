import 'package:flutter/material.dart';
import 'package:musicorum/api/models/wiki.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/pages/wiki_page.dart';

class WikiCard extends StatelessWidget {
  const WikiCard(this.wiki, {this.predominantColor, this.title = 'BIOGRAPHY', this.subTitle});

  final String title;
  final String subTitle;
  final Wiki wiki;
  final Color predominantColor;

  @override
  Widget build(BuildContext context) {
    return ColoredCard(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WikiPage(wiki, predominantColor, title, subTitle)));
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
            Text(wiki != null ? wiki.summaryFiltered : 'Loading...'),
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
