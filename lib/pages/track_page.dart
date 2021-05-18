import 'package:flutter/material.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/track_resource.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/api/musicorum.dart';
import 'package:musicorum/components/animated_appbar.dart';
import 'package:musicorum/components/content_header.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/content_stat.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/items/track_list_item.dart';
import 'package:musicorum/components/items/view_more_list_item.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/components/tags_fragment.dart';
import 'package:musicorum/components/two_layered_appbar.dart';
import 'package:musicorum/components/wiki_card.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/artist.dart';
import 'package:musicorum/pages/extended_items_list.dart';
import 'package:musicorum/states/login.dart';
import 'package:musicorum/utils/common.dart';
import 'package:provider/provider.dart';

class TrackPage extends StatefulWidget {
  TrackPage(this.track, this.user, {this.artist});

  final Track track;
  final Artist artist;
  final User user;

  @override
  TrackPageState createState() => TrackPageState();
}

class TrackPageState extends State<TrackPage> {
  Track fullTrack;
  Artist artist;
  List<Track> similar;
  bool fetchedSimilarTracks = false;

  Color predominantColor;

  ScrollController controller = ScrollController();
  final _scrollOffsetNotifier = ValueNotifier<double>(0.0);

  Track get track {
    return fullTrack != null ? fullTrack : widget.track;
  }

  ImageProvider get backgroundImage {
    if (artist != null &&
        artist.resource != null &&
        artist.resource.image != null) {
      return Image.network(artist.resource.image).image;
    }
    return null;
  }

  ImageProvider get mainImage {
    if (track.images != null && !track.images.isNull) {
      return track.images.getExtraLargeImage().image;
    } else if (track.resource != null && track.resource.image != null) {
      return Image.network(track.resource.image).image;
    }
    return null;
  }

  @override
  void initState() {
    _fetchData();
    if (controller != null) {
      controller.addListener(() {
        if (!controller.hasClients) return;
        _scrollOffsetNotifier.value = controller.offset;
      });
    }

    super.initState();
  }

  _fetchData() async {
    _handleArtist();
    _fetchTrack();
    _fetchSimilarTracks();
  }

  _fetchTrack() async {
    var _trackData = await LastfmAPI.getTrackInfo(
        widget.track.name, widget.track.artist, widget.user.username);
    setState(() {
      fullTrack = _trackData;
    });
    if (mainImage != null) {
      predominantColor =
          await CommonUtils.getDarkPredominantColorFromImageProvider(
              mainImage, Colors.white.withAlpha(50));
    } else {
      await track.getResource();
      predominantColor =
          await CommonUtils.getDarkPredominantColorFromImageProvider(
              mainImage, Colors.white.withAlpha(50));
    }
    setState(() {});
  }

  _fetchSimilarTracks() async {
    var tracks =
        await LastfmAPI.getTracksSimilar(track.name, widget.track.artist);
    setState(() {
      fetchedSimilarTracks = true;
      similar = tracks;
    });
    await TrackResource.getResources(similar);
    setState(() {});
  }

  _handleArtist() async {
    if (widget.artist == null) {
      artist = await LastfmAPI.getArtistInfo(
          widget.track.artist, widget.user.username);
    } else {
      artist = widget.artist;
    }
    if (artist.resource == null) {
      await artist.getResource();
      setState(() {});
    }
  }

  Future<void> _refresh() async {
    await _fetchData();
  }

  _getItemsList(List<dynamic> items) {
    return items != null ? items : [];
  }

  @override
  Widget build(BuildContext context) {
    var similarTracks = _getItemsList(similar)
        .map((t) =>
            TrackListItem(track: t, type: TrackListItemDisplayType.PLAYCOUNT))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AnimatedAppBar(
        name: track.name,
        secondary: track.artist,
        image: mainImage,
        notifier: _scrollOffsetNotifier,
      ),
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshIndicator(
            child: ListView(controller: controller, children: [
              ContentHeader(
                squareImage: true,
                loaded: true,
                name: track.name,
                secondary: track.artist,
                mainImage: mainImage,
                backgroundImage: backgroundImage,
                loadingColor: predominantColor,
                imageViewURL: track.images != null && !track.images.isNull ? track.images.getImageURLFromSize(1600, 0) : (track.resource != null && track.resource.image != null ? track.resource.image : null),
                onSecondaryTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtistPage(artist, widget.user),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ContentStat(
                          text: 'Playcount', value: track.globalPlayCount),
                      ContentStat(text: 'Listeners', value: track.listeners)
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ContentStat(
                          text: 'Your scrobbles', value: track.playCount),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
                child: Column(
                  children: [
                    TagsFragment(track.tags, predominantColor),
                    SizedBox(
                      height: 8.0,
                    ),
                    ContentItemList(
                      name: 'Similar tracks',
                      items: fetchedSimilarTracks && (similar == null || (similar != null && similar.length == 0))
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : fetchedSimilarTracks && similar != null
                              ? [
                                  ...similarTracks.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Similar tracks',
                                          track.name,
                                          similarTracks);
                                    },
                                  )
                                ]
                              : [
                                  ...List(5)
                                      .map((_) => ListItemPlaceholder())
                                      .toList(),
                                  ViewMoreListItem(
                                    placeHolder: true,
                                  )
                                ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    (track.wiki != null
                        ? WikiCard(
                            track.wiki,
                            predominantColor: predominantColor,
                            title: 'More about the track',
                            subTitle: track.name,
                          )
                        : Ink())
                  ],
                ),
              ),
              SizedBox(
                height: LIST_PADDING,
              )
            ]),
            onRefresh: _refresh,
          )),
    );
  }
}
