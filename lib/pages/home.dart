import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/list_content.dart';
import 'package:musicorum/components/musicorum_page_route.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/components/title.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/album_page.dart';
import 'package:musicorum/pages/settings_page.dart';
import 'package:musicorum/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:musicorum/states/login.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tinycolor/tinycolor.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

const COLOR_DEFAULT = Color.fromRGBO(255, 255, 255, 0.1);
const COLOR_DEFAULT_NON_ALPHA = Color(0xff2b2b2b);

const PICTURE_SIZE = 90.0;

const SCROLL_ITEM_SIZE = 130.0;
const SCROLL_ITEM_BORDER = 8.0;
const SCROLL_ITEM_MARGIN = 14.0;

var boxesPlaceholder = ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: 5,
  itemBuilder: (context, index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(right: SCROLL_ITEM_MARGIN),
        child: SizedBox(
          width: SCROLL_ITEM_SIZE,
          height: SCROLL_ITEM_SIZE,
          child: DecoratedBox(
              decoration: BoxDecoration(
                  color: COLOR_DEFAULT,
                  borderRadius: new BorderRadius.all(
                      Radius.circular(SCROLL_ITEM_BORDER)))),
        ),
      ),
    );
  },
);

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  PaletteGenerator paletteGenerator;
  User user;
  List<Track> recentTracks;
  List<Album> topAlbumsThisWeek;

  @override
  bool get wantKeepAlive => true;

  Future<void> _getImageColors() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        user.images.getSmallImage().image,
        maximumColorCount: 20);
    setState(() {});
  }

  _setUser(User usr) {
    setState(() {
      user = usr;
    });

    _doRequests();
  }

  _doRequests() async {
    var _recentTracks = await LastfmAPI.getRecentTracks(user.username);
    var _topAlbums = await LastfmAPI.getTopAlbums(user.username, Period.WEEK);
    setState(() {
      recentTracks = _recentTracks;
      topAlbumsThisWeek = _topAlbums;
    });
  }

  Color handleColor(PaletteGenerator generator) {
    return CommonUtils.getDarkPredominantColor(
        paletteGenerator, COLOR_DEFAULT_NON_ALPHA);
  }

  Future<void> _doRefresh() async {
    LastfmAPI.getUserInfo(user.username).then((_user) {
      setState(() {
        user = _user;
      });
      Provider.of<AuthState>(context).setUser(_user);
    });
    await _doRequests();
  }

  @override
  Widget build(BuildContext context) {
    Color gradientColor = handleColor(paletteGenerator);
    return Consumer<AuthState>(builder: (context, loginState, child) {
      if (user == null && loginState.isUserLoaded) {
        Future.delayed(Duration.zero, () async {
          _setUser(loginState.user);
          _getImageColors();
        });
      }
      bool isLoggedIn = user != null && loginState.isUserLoaded;
      return Scaffold(
        body: RefreshIndicator(
            child: ListView(
              padding: EdgeInsets.only(left: LIST_PADDING, right: LIST_PADDING),
              children: [
                PageTitle(
                  'Home',
                  actions: [
                    IconButton(
                        icon: Icon(Icons.settings_rounded),
                        onPressed: () =>
                            Provider.of<AuthState>(context, listen: false)
                                .rootNavigator
                                .push(
                              createPageRoute(
                                     SettingsPage()),
                                ))
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: isLoggedIn
                                ? [
                                    gradientColor,
                                    gradientColor
                                        .toTinyColor()
                                        .lighten(14)
                                        .color
                                  ]
                                : [GRADIENT_DEFAULT_1, GRADIENT_DEFAULT_2],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        color: Color.fromRGBO(0, 0, 0, 0.8),
                        borderRadius: new BorderRadius.all(
                            Radius.circular(BORDER_RADIUS))),
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                          Radius.circular(BORDER_RADIUS)),
                        child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: isLoggedIn
                            ? [
                                CircleAvatar(
                                    radius: PICTURE_SIZE / 2,
                                    backgroundImage:
                                        user.images.getExtraLargeImage().image),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        user.name != ''
                                            ? user.name
                                            : user.username,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    Text('${user.playCount} scrobbles')
                                  ],
                                )
                              ]
                            : [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: COLOR_DEFAULT),
                                  width: PICTURE_SIZE,
                                  height: PICTURE_SIZE,
                                  margin: EdgeInsets.only(right: 10.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(100)),
                                          color: COLOR_DEFAULT),
                                      width: 200,
                                      height: 28,
                                      margin: EdgeInsets.only(bottom: 8.0),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(100)),
                                          color: COLOR_DEFAULT),
                                      width: 90,
                                      height: 20,
                                    )
                                  ],
                                )
                              ],
                      ),
                    ),
          onTap: () {
            Provider.of<AuthState>(context, listen: false).selectedBottomItem = 4;
          },
        )
      ),
                ListContent(
                    text: 'Recent scrobbles',
                    content: Container(
                      height: SCROLL_ITEM_SIZE,
                      child: recentTracks != null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recentTracks.length,
                              itemBuilder: (context, index) {
                                Track track = recentTracks[index];
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: SCROLL_ITEM_MARGIN),
                                    child: RoundedImage(
                                      track.images.isNull
                                          ? track.images.defaultImageURL
                                          : track.images.extraLarge,
                                      width: SCROLL_ITEM_SIZE,
                                      height: SCROLL_ITEM_SIZE,
                                      radius: SCROLL_ITEM_BORDER,
                                    ),
                                  ),
                                );
                              },
                            )
                          : boxesPlaceholder,
                    )),
                ListContent(
                    text: 'Most listened this week',
                    content: Container(
                      height: SCROLL_ITEM_SIZE,
                      child: topAlbumsThisWeek != null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topAlbumsThisWeek.length,
                              itemBuilder: (context, index) {
                                Album album = topAlbumsThisWeek[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                    createPageRoute(
                                         AlbumPage(
                                          album,
                                          null,
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: SCROLL_ITEM_MARGIN),
                                      child: RoundedImage(
                                        album.images.isNull
                                            ? album.images.defaultImageURL
                                            : album.images.extraLarge,
                                        width: SCROLL_ITEM_SIZE,
                                        height: SCROLL_ITEM_SIZE,
                                        radius: SCROLL_ITEM_BORDER,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : boxesPlaceholder,
                    )),
                ListContent(
                    text: 'Friends activity',
                    content: Container(
                      height: 160.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return FriendActiviy(
                            skeleton: true,
                          );
                        },
                      ),
                    )),
                SizedBox(
                  height: 60,
                )
              ],
            ),
            onRefresh: _doRefresh),
        backgroundColor: SURFACE_COLOR,
      );
    });
  }
}

class FriendActiviy extends StatelessWidget {
  FriendActiviy({this.user, this.track, this.listening, this.skeleton});

  final User user;
  final Track track;
  final bool listening;
  final bool skeleton;

  @override
  Widget build(BuildContext context) {
    if (skeleton)
      return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(right: SCROLL_ITEM_MARGIN),
              width: SCROLL_ITEM_SIZE,
              height: SCROLL_ITEM_SIZE,
              decoration: BoxDecoration(
                  color: COLOR_DEFAULT,
                  borderRadius: new BorderRadius.all(
                      Radius.circular(SCROLL_ITEM_BORDER)))),
          Positioned(
              top: SCROLL_ITEM_SIZE - 32,
              left: SCROLL_ITEM_SIZE - 32,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    border: Border.all(color: SURFACE_COLOR, width: 4.0),
                    color: COLOR_DEFAULT_NON_ALPHA.lighten(5),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ))
        ],
      );
  }
}
