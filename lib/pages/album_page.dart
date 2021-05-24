import 'package:flutter/material.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/animated_appbar.dart';
import 'package:musicorum/components/content_header.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/content_stat.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/items/track_list_item.dart';
import 'package:musicorum/components/items/view_more_list_item.dart';
import 'package:musicorum/components/musicorum_page_route.dart';
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

class AlbumPage extends StatefulWidget {
  AlbumPage(this.album, this.artist, {this.user});

  final Album album;
  final Artist artist;
  final User user;

  @override
  AlbumPageState createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  Album fullAlbum;
  Artist artist;

  Color predominantColor;

  ScrollController controller = ScrollController();
  final _scrollOffsetNotifier = ValueNotifier<double>(0.0);

  bool trackListFetched = false;

  Album get album {
    return fullAlbum != null ? fullAlbum : widget.album;
  }

  ImageProvider get backgroundImage {
    if (artist != null &&
        artist.resource != null &&
        artist.resource.image != null) {
      return Image.network(artist.resource.image).image;
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
    _fetchAlbum();
  }

  _fetchAlbum() async {
    var _albumData = await LastfmAPI.getAlbumInfo(
        album.name, album.artist, widget.user.username);
    setState(() {
      fullAlbum = _albumData;
      trackListFetched = true;
    });
    predominantColor =
        await CommonUtils.getDarkPredominantColorFromImageProvider(
            _albumData.images.getMediumImage().image,
            Colors.white.withAlpha(50));
    setState(() {});
  }

  _handleArtist() async {
    if (widget.artist == null) {
      artist = await LastfmAPI.getArtistInfo(
          widget.album.artist, widget.user.username);
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
   var tracksList = _getItemsList(album.tracks != null ? album.tracks : [])
        .map((t) => TrackListItem(
              track: t,
              type: TrackListItemDisplayType.PLAYCOUNT,
              order: t.rank,
            ))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AnimatedAppBar(
        name: album.name,
        secondary: album.artist,
        image: album.images.getMediumImage().image,
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
                name: album.name,
                secondary: album.artist,
                loadingColor: predominantColor,
                mainImage: album.images.getExtraLargeImage().image,
                imageViewURL: album.images.getImageURLFromSize(1600, 0),
                backgroundImage: backgroundImage,
                onSecondaryTap: () {
                  if (artist == null) return;
                  Navigator.push(
                    context,
                    createPageRoute(
                      ArtistPage(artist, widget.user),
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
                          text: 'Playcount', value: album.globalPlayCount),
                      ContentStat(text: 'Listeners', value: album.listeners)
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ContentStat(
                          text: 'Your scrobbles', value: album.playCount),
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
                    TagsFragment(album.tags, predominantColor),
                    SizedBox(
                      height: 8.0,
                    ),
                    ContentItemList(
                      name: 'Tracks',
                      items: trackListFetched &&
                              (album.tracks == null || album.tracks.length == 0)
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : trackListFetched && album.tracks != null
                              ? [...tracksList]
                              : List(5)
                                  .map((_) => ListItemPlaceholder())
                                  .toList(),
                    ),
                    // ContentItemList(
                    //   name: 'Top albums',
                    //   items: topAlbumsFetched && topAlbums == null
                    //       ? [
                    //     Center(
                    //       child: Text('Nothing found.'),
                    //     )
                    //   ]
                    //       : topAlbumsFetched && topAlbums != null
                    //       ? [
                    //     ...topAlbumsItems.take(5),
                    //     ViewMoreListItem(
                    //       onTap: () {
                    //         ExtendedItemsListPage.openItemsPage(
                    //             context,
                    //             'Top albums',
                    //             artist.name,
                    //             topAlbumsItems);
                    //       },
                    //     )
                    //   ]
                    //       : [
                    //     ...List(5)
                    //         .map((_) => ListItemPlaceholder())
                    //         .toList(),
                    //     ViewMoreListItem(
                    //       placeHolder: true,
                    //     )
                    //   ],
                    // ),
                    // ListContent(
                    //     text: 'Similar artists',
                    //     content: Container(
                    //       height: 100.0,
                    //       child: ListView.builder(
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount:
                    //         isArtistFetched ? artist.similar.length : 2,
                    //         itemBuilder: (context, index) {
                    //           if (!isArtistFetched) {
                    //             return Container(
                    //               margin: EdgeInsets.only(
                    //                   left: index == 0 ? 0.0 : 12.0),
                    //               decoration: BoxDecoration(
                    //                   shape: BoxShape.circle,
                    //                   color: PLACEHOLDER_COLOR),
                    //               width: SCROLL_ITEM_SIZE,
                    //               height: SCROLL_ITEM_SIZE,
                    //             );
                    //           }
                    //           return Align(
                    //             alignment: Alignment.topLeft,
                    //             child: Container(
                    //                 margin: EdgeInsets.only(
                    //                     left: index == 0 ? 0.0 : 12.0),
                    //                 child: Material(
                    //                   shape: CircleBorder(),
                    //                   clipBehavior: Clip.hardEdge,
                    //                   color: Colors.transparent,
                    //                   child: Ink.image(
                    //                       image: Image.network(artist
                    //                           .similar[index].imageURL)
                    //                           .image,
                    //                       width: SCROLL_ITEM_SIZE,
                    //                       height: SCROLL_ITEM_SIZE,
                    //                       fit: BoxFit.cover,
                    //                       child: InkWell(
                    //                         onTap: () {
                    //                           Navigator.push(
                    //                             context,
                    //                             createPageRoute(
                    //
                    //                                     ArtistPage(
                    //                                         artist
                    //                                             .similar[index],
                    //                                         widget.user)),
                    //                           );
                    //                         },
                    //                       )),
                    //                 )),
                    //           );
                    //         },
                    //       ),
                    //     )),
                    SizedBox(
                      height: 20.0,
                    ),
                    (album.wiki != null
                        ? WikiCard(
                            album.wiki,
                            predominantColor: predominantColor,
                            title: 'More about the album',
                            subTitle: album.name,
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