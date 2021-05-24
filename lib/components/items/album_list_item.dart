import 'package:flutter/material.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/musicorum_page_route.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:musicorum/pages/album_page.dart';

class AlbumListItem extends StatelessWidget {
  final Album album;
  final Artist artist;
  final User user;

  const AlbumListItem({this.album, this.artist, this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          new BorderRadius.all(Radius.circular(CONTENT_LIST_BOX_BORDER)),
      onTap: () {
        Navigator.push(
          context,
          createPageRoute(AlbumPage(album, artist, user: this.user),
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
            RoundedImage(
              album.images.large,
              width: CONTENT_LIST_IMAGE_WIDTH + .0,
              height: CONTENT_LIST_IMAGE_WIDTH + .0,
              radius: CONTENT_LIST_IMAGE_BORDER_RADIUS,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    album.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: SURFACE_SECONDARY_TEXT_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 3.0),
              child: Text(
                '${NumberFormat.compact().format(album.playCount != null ? album.playCount : album.globalPlayCount)} plays',
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
