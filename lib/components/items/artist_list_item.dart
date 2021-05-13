import 'package:flutter/material.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/artist.dart';
import 'package:musicorum/pages/profile.dart';
import 'package:musicorum/pages/profile_page.dart';

class ArtistListItem extends StatelessWidget {
  final Artist artist;
  final User user;

  const ArtistListItem({@required this.artist, @required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(CONTENT_LIST_BOX_BORDER)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistPage(artist, user),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: CONTENT_LIST_MARGIN_V),
        padding: EdgeInsets.symmetric(
            horizontal: CONTENT_LIST_PADDING_H,
            vertical: CONTENT_LIST_PADDING_V),
        child: Row(
          children: [
            CircleAvatar(
              radius: CONTENT_LIST_IMAGE_WIDTH / 2,
              backgroundImage: Image.network(artist.imageURL).image,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
                  artist.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
            Container(
              margin: EdgeInsets.only(left: 3.0),
              child: Text(
                artist.playCount.toString() + ' plays',
                style: TextStyle(
                    fontSize: 10, color: SURFACE_SECONDARY_TEXT_COLOR),
              ),
            )
          ],
        ),
      ),
    );
  }
}
