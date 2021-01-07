import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/artist_resource.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/track_resource.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/components/content_header.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/content_stat.dart';
import 'package:musicorum/components/items/album_list_item.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/items/track_list_item.dart';
import 'package:musicorum/components/items/view_more_list_item.dart';
import 'package:musicorum/components/list_content.dart';
import 'package:musicorum/components/tags_fragment.dart';
import 'package:musicorum/components/wiki_card.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/extended_items_list.dart';
import 'package:musicorum/pages/home.dart';
import 'package:musicorum/utils/common.dart';

class ArtistPage extends StatefulWidget {
  final Artist _artist;
  final User user;

  ArtistPage(this._artist, this.user);

  @override
  ArtistPageState createState() => ArtistPageState();
}

class ArtistPageState extends State<ArtistPage> {
  Artist fullArtist;
  List<Album> topAlbums;
  List<Track> topTracks;
  Color predominantColor;

  bool topAlbumsFetched = false;
  bool topTracksFetched = false;

  ScrollController controller = ScrollController();
  double scrollOffset = 0.0;

  Artist get artist {
    return fullArtist != null ? fullArtist : widget._artist;
  }

  bool get isArtistFetched {
    return fullArtist != null;
  }

  @override
  void initState() {
    _fetchData();
    if (controller != null) {
      controller.addListener(() {
        if (!controller.hasClients) return;
        setState(() {
          scrollOffset = controller.offset;
        });
      });
    }

    super.initState();
  }

  _fetchData() async {
    LastfmAPI.getArtistTopAlbums(artist.name)
      ..then((value) => setState(() {
            topAlbums = value;
            topAlbumsFetched = true;
          }));

    _fetchArtist();
    _fetchTracks();
  }

  _fetchArtist() async {
    Artist dataArtist = await LastfmAPI.getArtistInfo(
        widget._artist.name, widget.user.username);
    dataArtist.resource = widget._artist.resource;
    setState(() {
      fullArtist = dataArtist;
    });

    predominantColor =
        await CommonUtils.getDarkPredominantColorFromImageProvider(
            Image.network(dataArtist.resource.image).image,
            Colors.white.withAlpha(50));
    setState(() {});

    await ArtistResource.getResources(fullArtist.similar);
    setState(() {});
  }

  _fetchTracks() async {
    topTracks = await LastfmAPI.getArtistTopTracks(artist.name);
    setState(() {
      topTracksFetched = true;
    });
    if (topTracks != null && topTracks.length > 0)
      await TrackResource.getResources(topTracks);
    setState(() {});
  }

  Future<void> _refresh() async {
    await _fetchData();
  }

  String get backgroundImage {
    if (topAlbums != null && topAlbums.length > 0) {
      for (var i = 0; i < topAlbums.length; i++) {
        if (!topAlbums[i].images.isNull)
          return topAlbums[i]
              .images
              .getImageURLFromSize(600)
              .replaceAll('.png', '.jpg');
      }
      return null;
    }
    return null;
  }

  _getItemsList(List<dynamic> items) {
    return items != null ? items : [];
  }

  @override
  Widget build(BuildContext context) {
    var appBarVisibility =
        ContentHeader.getHeaderFractionFromOffset(context, scrollOffset);

    var topTracksItems = _getItemsList(topTracks)
        .map((t) =>
            TrackListItem(track: t, type: TrackListItemDisplayType.PLAYCOUNT))
        .toList();

    var topAlbumsItems =
        _getItemsList(topAlbums).map((t) => AlbumListItem(album: t, artist: artist, user: widget.user,)).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        title: Opacity(
          opacity: appBarVisibility,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: Image.network(artist.imageURL).image,
                radius: 16,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                artist.name,
              )
            ],
          ),
        ),
        backgroundColor:
            Colors.black.withAlpha((appBarVisibility * 200).toInt()),
      ),
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshIndicator(
            child: ListView(controller: controller, children: [
              ContentHeader(
                loaded: true,
                name: artist.name,
                mainImage: artist.resource != null && artist.resource.image != null ? Image.network(artist.resource.image).image : null,
                backgroundImage: backgroundImage != null
                    ? Image.network(backgroundImage).image
                    : null,
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
                          text: 'Playcount', value: artist.globalPlayCount),
                      ContentStat(text: 'Listeners', value: artist.listeners)
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ContentStat(
                          text: 'Your scrobbles', value: artist.playCount),
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
                    TagsFragment(artist.tags, predominantColor),
                    SizedBox(
                      height: 8.0,
                    ),
                    ContentItemList(
                      name: 'Top tracks',
                      items: topTracksFetched && topTracks == null
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : topTracksFetched && topTracks != null
                              ? [
                                  ...topTracksItems.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Top tracks',
                                          artist.name,
                                          topTracksItems);
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
                    ContentItemList(
                      name: 'Top albums',
                      items: topAlbumsFetched && topAlbums == null
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : topAlbumsFetched && topAlbums != null
                              ? [
                                  ...topAlbumsItems.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Top albums',
                                          artist.name,
                                          topAlbumsItems);
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
                    ListContent(
                        text: 'Similar artists',
                        content: Container(
                          height: 100.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                isArtistFetched ? artist.similar.length : 2,
                            itemBuilder: (context, index) {
                              if (!isArtistFetched) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: index == 0 ? 0.0 : 12.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PLACEHOLDER_COLOR),
                                  width: SCROLL_ITEM_SIZE,
                                  height: SCROLL_ITEM_SIZE,
                                );
                              }
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 0.0 : 12.0),
                                    child: Material(
                                      shape: CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      color: Colors.transparent,
                                      child: Ink.image(
                                          image: Image.network(artist
                                                  .similar[index].imageURL)
                                              .image,
                                          width: SCROLL_ITEM_SIZE,
                                          height: SCROLL_ITEM_SIZE,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ArtistPage(
                                                            artist
                                                                .similar[index],
                                                            widget.user)),
                                              );
                                            },
                                          )),
                                    )),
                              );
                            },
                          ),
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    WikiCard(artist.wiki, predominantColor: predominantColor, title: 'Biography', subTitle: artist.name,)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ]),
            onRefresh: _refresh,
          )),
    );
  }
}