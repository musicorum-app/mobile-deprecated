import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/artist_resource.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/track_resource.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/content_header.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/content_stat.dart';
import 'package:musicorum/components/items/album_list_item.dart';
import 'package:musicorum/components/items/artist_list_item.dart';
import 'package:musicorum/components/items/placeholder.dart';
import 'package:musicorum/components/items/track_list_item.dart';
import 'package:musicorum/components/items/user_list_item.dart';
import 'package:musicorum/components/items/view_more_list_item.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/extended_items_list.dart';

class Profile extends StatefulWidget {
  final User user;
  final User loggedInUser;
  final ScrollController controller;

  const Profile(this.user, {this.controller, this.loggedInUser});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  List<Artist> topArtistsOverall;
  Artist artistBackground;
  bool loaded = false;
  List<User> friends;
  List<Track> recentScrobbles;
  List<Track> topTracks;
  List<Album> topAlbums;

  @override
  void initState() {
    _fetchData();

    super.initState();
  }

  _fetchScrobbles() async {
    var tracks = await LastfmAPI.getRecentTracks(widget.user.username);

    setState(() {
      recentScrobbles = tracks;
    });
  }

  _fetchData() async {
    _fetchAlbums();
    _fetchTracks();
    _fetchScrobbles();

    topArtistsOverall =
        await LastfmAPI.getTopArtists(widget.user.username, Period.OVERALL);

    _getResources();

    var topArtistsWeek =
        await LastfmAPI.getTopArtists(widget.user.username, Period.WEEK);
    if (topArtistsWeek.length > 0) {
      artistBackground = topArtistsWeek[0];
    } else {
      artistBackground = topArtistsOverall[0];
    }

    try {
      friends = await LastfmAPI.getFriends(widget.user.username);
    } catch (_) {
      friends = null;
    }

    artistBackground.getResource().then((value) => setState(() {}));

    setState(() {
      loaded = true;
    });
  }

  _fetchAlbums() async {
    topAlbums =
        await LastfmAPI.getTopAlbums(widget.user.username, Period.OVERALL);
    setState(() {});
  }

  _fetchTracks() async {
    topTracks =
        await LastfmAPI.getTopTracks(widget.user.username, Period.OVERALL);
    setState(() {});
    await TrackResource.getResources(topTracks);
    setState(() {});
  }

  _getResources() async {
    await ArtistResource.getResources(topArtistsOverall);
    setState(() {});
  }

  Future<void> _refresh() async {
    await _fetchData();
  }

  _getItemsList(List<dynamic> items) {
    return items != null ? items : [];
  }

  @override
  Widget build(BuildContext context) {
    var recentScrobblesItems = _getItemsList(recentScrobbles)
        .map((t) => TrackListItem(
            track: t, type: TrackListItemDisplayType.RECENT_SCROBBLE))
        .toList();

    var topArtistsItems = _getItemsList(topArtistsOverall)
        .map((a) => ArtistListItem(artist: a, user: widget.loggedInUser))
        .toList();

    var topAlbumsItems = _getItemsList(topAlbums)
        .map((a) => AlbumListItem(
              album: a,
      user: widget.loggedInUser,
            ))
        .toList();

    var topTracksItems = _getItemsList(topTracks)
        .map((t) =>
            TrackListItem(track: t, type: TrackListItemDisplayType.PLAYCOUNT))
        .toList();

    var friendsItems = _getItemsList(friends)
        .map((u) => UserListItem(
              user: u,
            ))
        .toList();

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshIndicator(
          child: ListView(controller: widget.controller, children: [
            ContentHeader(
              loaded: loaded,
              name: widget.user.name != null
                  ? widget.user.name
                  : widget.user.username,
              secondary: '@${widget.user.username}',
              mainImage: widget.user.images.getExtraLargeImage().image,
              backgroundImage:
                  artistBackground != null && artistBackground.resource != null
                      ? Image.network(artistBackground.resource.image).image
                      : null,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '${widget.user.country} • scrobbling since ${widget.user.getRegisteredDate().year}',
              style: TextStyle(
                color: SURFACE_SECONDARY_TEXT_COLOR,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentStat(
                  text: 'Scrobbles',
                  value: widget.user.playCount,
                ),
                ContentStat(
                  text: 'Scrobbles',
                  value: widget.user.playCount,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
                child: Column(
                  children: [
                    ContentItemList(
                      name: 'Recent scrobbles',
                      items: loaded
                          ? [
                              ...recentScrobblesItems.take(5),
                              ViewMoreListItem(
                                onTap: () {
                                  ExtendedItemsListPage.openItemsPage(
                                      context,
                                      'Recent scrobbles',
                                      widget.user.displayName,
                                      recentScrobblesItems);
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
                      name: 'Top artists',
                      items: loaded && topArtistsOverall == null
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : loaded
                              ? [
                                  ...topArtistsItems.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Top artists - overall',
                                          widget.user.displayName,
                                          topArtistsItems);
                                    },
                                  )
                                ]
                              : [
                                  ...List(5)
                                      .map((_) => ListItemPlaceholder(
                                            type:
                                                ListItemPlaceholderType.ARTIST,
                                          ))
                                      .toList(),
                                  ViewMoreListItem(
                                    placeHolder: true,
                                  )
                                ],
                    ),
                    ContentItemList(
                      name: 'Top albums',
                      items: loaded && topAlbums == null
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : loaded && topAlbums != null
                              ? [
                                  ...topAlbumsItems.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Top albums - overall',
                                          widget.user.displayName,
                                          topAlbumsItems);
                                    },
                                  )
                                ]
                              : [
                                  ...List(5)
                                      .map((_) => ListItemPlaceholder(
                                            type:
                                                ListItemPlaceholderType.ARTIST,
                                          ))
                                      .toList(),
                                  ViewMoreListItem(
                                    placeHolder: true,
                                  )
                                ],
                    ),
                    ContentItemList(
                      name: 'Top tracks',
                      items: loaded && topTracks == null
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : loaded && topTracks != null
                              ? [
                                  ...topTracksItems.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Top tracks - overall',
                                          widget.user.displayName,
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
                      name: 'Friends',
                      items: loaded && friends == null
                          ? [
                              Center(
                                child: Text('Nothing found.'),
                              )
                            ]
                          : loaded
                              ? [
                                  ...friendsItems.take(5),
                                  ViewMoreListItem(
                                    onTap: () {
                                      ExtendedItemsListPage.openItemsPage(
                                          context,
                                          'Friends',
                                          widget.user.displayName,
                                          friendsItems);
                                    },
                                  )
                                ]
                              : [
                                  ...List(5)
                                      .map((_) => ListItemPlaceholder(
                                            type: ListItemPlaceholderType.USER,
                                          ))
                                      .toList(),
                                  ViewMoreListItem(
                                    placeHolder: true,
                                  )
                                ],
                    )
                  ],
                ))
          ]),
          onRefresh: _refresh,
        ));
  }
}
