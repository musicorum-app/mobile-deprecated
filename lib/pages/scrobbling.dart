import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/items/track_list_item.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/components/title.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/states/login.dart';
import 'package:musicorum/utils/common.dart';
import 'package:provider/provider.dart';

class ScrobblingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScrobblingPageState();
  }
}

class ScrobblingPageState extends State<ScrobblingPage> {
  User user;
  List<Track> _scrobbles;
  Color playingTrackColor;
  bool started = false;
  Timer timer;
  Track playingTrackInfo;

  _doRequests(User usr) {
    print(usr);
    setState(() {
      user = usr;
    });
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _fetchScrobbles());
    _fetchScrobbles();
  }

  _fetchScrobbles() async {
    print('fetching scrobbles...');
    var tracks = await LastfmAPI.getRecentTracks(user.username);

    var authState = Provider.of<AuthState>(context, listen: false);

    setState(() {
      _scrobbles = tracks;
    });
    if (isPlaying) {
      playingTrackColor =
          await CommonUtils.getDarkPredominantColorFromImageProvider(
              playingTrack.images.getMediumImage().image);
      setState(() {});
      var currTrack = await LastfmAPI.getTrackInfo(playingTrack.name, playingTrack.artist, user.username);
      setState(() {
        playingTrackInfo = currTrack;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchScrobbles();
  }

  bool get loaded {
    return _scrobbles != null;
  }


  List<Track> get scrobbles {
    List<Track> list = [..._scrobbles];
    if (list[0].isPlaying) {
      list.removeAt(0);
    }
    return list;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Track get playingTrack {
    if (!loaded) return null;
    if (_scrobbles[0].isPlaying) return _scrobbles[0];
    return null;
  }

  bool get isPlaying {
    return playingTrack != null;
  }

  bool get isLoved {
    if (playingTrackInfo == null) return false;
    return playingTrackInfo.userLoved;
  }

  Widget _buildPlayingCard() {
    return ColoredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'now playing'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(.8)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6.0),
                child: RoundedImageProvider(
                  playingTrack.images.getLargeImage().image,
                  width: 90,
                  height: 90,
                  radius: 4.0,
                ),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: 3.0,
                      blurRadius: 4.0)
                ]),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playingTrack.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Text(
                        playingTrack.artist,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     IconButton(
                         icon: Icon(isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                         onPressed: playingTrackInfo == null ? null : () {},
                     )
                   ],
                 )
                ],
              ))
            ],
          )
        ],
      ),
      mainColor: playingTrackColor,
      padding: EdgeInsets.all(12.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!started) {
      if (Provider.of<AuthState>(context) != null && Provider.of<AuthState>(context).user != null) {
        setState(() {
          started = true;
        });
        _doRequests(Provider.of<AuthState>(context).user);
      }
    }
    return RefreshIndicator(
        child: ListView(
          padding: EdgeInsets.only(left: LIST_PADDING, right: LIST_PADDING),
          children: [
            PageTitle('Scrobbling'),
            Container(
              child: isPlaying ? _buildPlayingCard() : Container(),
            ),
            ContentItemList(
                name: 'Recent scrobbles',
                items: loaded
                    ? scrobbles
                        .map((s) => TrackListItem(
                              track: s,
                              type: TrackListItemDisplayType.RECENT_SCROBBLE,
                            ))
                        .toList()
                    : List(10).map((_) => ListItemPlaceholder()).toList()),
          ],
        ),
        onRefresh: _handleRefresh);
  }
}
