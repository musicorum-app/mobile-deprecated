import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/image.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/items/track_list_item.dart';
import 'package:musicorum/components/more_bottom_sheet.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/components/title.dart';
import 'package:musicorum/components/title_sliver_delegate.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/charts.dart';
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
  Track _playingTrackInfo;

  _doRequests(User usr) {
    print(usr);
    setState(() {
      user = usr;
    });
    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => _fetchScrobbles());
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
          playingTrack.images
              .getMediumImage()
              .image);
      setState(() {});
      var currTrack = await LastfmAPI.getTrackInfo(
          playingTrack.name, playingTrack.artist, user.username);
      setState(() {
        _playingTrackInfo = currTrack;
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

  Track get playingTrackInfo => _playingTrackInfo ?? playingTrack;

  bool get isLoved {
    if (playingTrackInfo == null) return false;
    return playingTrackInfo.userLoved;
  }

  _openSheet() {
    print('open');
    MoreBottomSheet.openBottomSheet(context: context,
        item: MoreBottomSheet(
            image: playingTrack.images.getLargeImage().image,
            title: playingTrack.name,
            subTitle: playingTrack.artist,
            items: [
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!started) {
      if (Provider.of<AuthState>(context) != null &&
          Provider
              .of<AuthState>(context)
              .user != null) {
        setState(() {
          started = true;
        });
        _doRequests(Provider
            .of<AuthState>(context)
            .user);
      }
    }
    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
        [
          SliverPersistentHeader(
            delegate: TabBarToolbarDelegate(
                color: SURFACE_COLOR,
                height: MediaQuery
                    .of(context)
                    .padding
                    .top),
            pinned: true,
          ),
          SliverPersistentHeader(
            delegate: PageTitleSliverDelegate(
                pageTitle: PageTitle(
                  'Scrobbling',
                  margin: false,
                )),
          ),
          SliverPersistentHeader(
            delegate: NowPlayingCardDelegate(
                track: playingTrack,
                boxColor: playingTrackColor,
                image: isPlaying
                    ? playingTrack.images
                    .getExtraLargeImage()
                    .image
                    : DEFAULT_TRACK.image,
                onTap: _openSheet,
                isLoved: isLoved),
            pinned: true,
          )
        ],
        body: RefreshIndicator(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
              children: [
                ContentItemList(
                    name: 'Recent scrobbles',
                    items: loaded
                        ? scrobbles
                        .map((s) =>
                        TrackListItem(
                          track: s,
                          type:
                          TrackListItemDisplayType.RECENT_SCROBBLE,
                        ))
                        .toList()
                        : List(10).map((_) => ListItemPlaceholder()).toList()),
              ],
            ),
            onRefresh: _handleRefresh),
      ),
    );
  }
}

class NowPlayingCardDelegate extends SliverPersistentHeaderDelegate {
  NowPlayingCardDelegate({@required this.track,
    @required this.boxColor,
    @required this.image,
    @required this.isLoved,
    this.onTap
  });

  final Track track;
  final Color boxColor;
  final ImageProvider image;
  final bool isLoved;
  final GestureTapCallback onTap;

  final _paddingTween =
  EdgeInsetsTween(begin: EdgeInsets.all(12.0), end: EdgeInsets.all(8.0));

  final _alignTween =
  AlignmentTween(begin: Alignment.topLeft, end: Alignment.centerLeft);

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    final progress = CommonUtils.convertRanges(
        shrinkOffset, 0, maxExtent - minExtent, 0.0, 1.0)
        .clamp(0.0, 1.0);

    if (track == null) {
      return Container(
          padding:
          EdgeInsets.symmetric(horizontal: LIST_PADDING, vertical: 8.0),
          color: SURFACE_COLOR,
          child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  gradient: ColoredCard.createGradient(null),
                  borderRadius: BorderRadius.circular(4.0)),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: Align(
                          child: Text('Nothing is being scrobbled.'),
                          alignment: _alignTween.lerp(progress),
                        ),
                      )
                    ],
                  )
                ],
              )));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: LIST_PADDING, vertical: 8.0),
      color: SURFACE_COLOR,
      child: Container(
          padding: _paddingTween.lerp(progress),
          decoration: BoxDecoration(
              gradient: ColoredCard.createGradient(boxColor),
              borderRadius: BorderRadius.circular(4.0)),
          child: InkWell(
            child: Stack(
              children: [
                Opacity(
                  opacity: 1 - progress,
                  child: Text(
                    'now playing'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(.8)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30 * (1 - progress)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: RoundedImageProvider(
                          track.images
                              .getExtraLargeImage()
                              .image,
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
                      Expanded(
                        child: Align(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                track.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              Text(
                                track.artist,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          alignment: _alignTween.lerp(progress),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Opacity(
                          opacity: 1 - progress,
                          child: Icon(isLoved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            onTap: () => onTap(),
          )),
    );
  }

  @override
  double get minExtent => 86;

  @override
  double get maxExtent => 170;

  @override
  bool shouldRebuild(NowPlayingCardDelegate oldDelegate) =>
      oldDelegate.track != track || oldDelegate.boxColor != boxColor;
}
