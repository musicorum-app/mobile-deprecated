import 'package:flutter/material.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:musicorum/pages/track_page.dart';
import 'package:musicorum/states/login.dart';
import 'package:provider/provider.dart';

enum TrackListItemDisplayType { RECENT_SCROBBLE, PLAYCOUNT }

class TrackListItem extends StatelessWidget {
  final Track track;
  final TrackListItemDisplayType type;
  final int order;

  const TrackListItem(
      {this.track, this.order, this.type = TrackListItemDisplayType.PLAYCOUNT});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          new BorderRadius.all(Radius.circular(CONTENT_LIST_BOX_BORDER)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TrackPage(track, Provider.of<LoginState>(context).user),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: CONTENT_LIST_MARGIN_V),
        padding: EdgeInsets.symmetric(
            horizontal: CONTENT_LIST_PADDING_H,
            vertical: CONTENT_LIST_PADDING_V),
        decoration: BoxDecoration(
            color: track.isPlaying ? Color(0x18ffffff) : Color(0x00000000),
            borderRadius:
                BorderRadius.all(Radius.circular(CONTENT_LIST_BOX_BORDER))),
        child: Row(
          children: [
            order != null
                ? SizedBox(
                    width: CONTENT_LIST_IMAGE_WIDTH + .0,
                    height: CONTENT_LIST_IMAGE_WIDTH / 2,
                    child: Center(
                      child: Text(
                        track.rank.toString(),
                        style: TextStyle(
                            fontSize: 16, color: SURFACE_SECONDARY_TEXT_COLOR),
                      ),
                    ),
                  )
                : RoundedImage(
                    type == TrackListItemDisplayType.RECENT_SCROBBLE
                        ? track.images.large != null &&
                                track.images.large != ''
                            ? track.images.large
                            : track.images.defaultImageURL
                        : track.resource != null &&
                                track.resource.image != null &&
                                track.resource.image != ''
                            ? track.resource.image
                            : track.images.defaultImageURL,
                    width: CONTENT_LIST_IMAGE_WIDTH + .0,
                    height: CONTENT_LIST_IMAGE_WIDTH + .0,
                    radius: CONTENT_LIST_IMAGE_BORDER_RADIUS,
                  ),
            SizedBox(
              width: order != null ? 5 : 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    track.artist,
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
                type == TrackListItemDisplayType.RECENT_SCROBBLE
                    ? track.isPlaying
                        ? 'Scrobbling now'
                        : Jiffy(track.streamedAt).fromNow()
                    : track.playCount != null
                        ? '${NumberFormat.compact().format(track.playCount)} plays'
                        : '',
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
