import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicorum/api/models/tag.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/content_stat.dart';
import 'package:musicorum/components/musicorum_page_route.dart';
import 'package:musicorum/components/tags_fragment.dart';
import 'package:musicorum/components/wiki_card.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/artist.dart';
import 'package:musicorum/pages/home.dart';
import 'package:musicorum/utils/common.dart';

class TagPage extends StatefulWidget {
  TagPage(this.tag);

  final Tag tag;

  @override
  State<StatefulWidget> createState() => TagPageState();
}

class TagPageState extends State<TagPage> {
  Color predominantColor;
  ImageProvider mainImage;

  Tag get tag {
    return widget.tag;
  }

  String get _mainImageURL {
    if (tag == null) return null;
    if (tag.topArtists == null) return null;
    if (tag.topArtists[0] == null) return null;
    if (tag.topArtists[0].resource == null) return null;

    return tag.topArtists[0].resource.image;
  }

  @override
  void initState() {
    _fetchData(false);

    super.initState();
  }

  _resolveImage() {
    final resource = tag.topArtists[0].resource;
    if (resource == null || resource.image == null) return;
    setState(() {
      mainImage = Image.network(tag.topArtists[0].resource.image).image;
    });

    CommonUtils.getDarkPredominantColorFromImageProvider(
            mainImage, Colors.white.withAlpha(50))
        .then((value) => setState(() {
              predominantColor = value;
            }));
  }

  _fetchData(bool force) async {
    if (tag.topArtists == null || force) {
      tag.fetchTopArtists()
        ..then((value) {
          setState(() {});
          tag.topArtists[0].getResource()
            ..then((value) {
              _resolveImage();
            });
        });
    } else {
      _resolveImage();
    }

    if (tag.total == null || force) {
      tag.fetchInfo().then((value) => setState(() {}));
    }
  }

  Future<void> _refresh() async {
    _fetchData(true);
  }

  _buildHeader() {
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              height: 311,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [SURFACE_COLOR.withAlpha(90), SURFACE_COLOR],
                stops: [0.3, 1],
                begin: FractionalOffset.topCenter,
                end: AlignmentDirectional.bottomCenter,
              )),
            ),
          ),
          Positioned(
              top: 240,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Text(
                  tag.name,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
      decoration: BoxDecoration(
          image: mainImage != null
              ? DecorationImage(fit: BoxFit.cover, image: mainImage)
              : null,
          color: mainImage == null ? PLACEHOLDER_COLOR : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                _buildHeader(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ContentStat(text: 'Used', value: tag.total),
                    ContentStat(text: 'Users', value: tag.reach)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
                  child: Column(
                    children: [
                      WikiCard(
                        tag.wiki,
                        title: 'About',
                        subTitle: tag.name,
                        predominantColor: predominantColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
                  child: Column(
                    children: [
                      ContentItemList(
                        name: 'Artists',
                        items: [
                          Container(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                              tag.topArtists != null ? tag.topArtists.length : 5,
                              itemBuilder: (context, index) {
                                if (tag.topArtists == null)
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 0.0 : 12.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: PLACEHOLDER_COLOR),
                                    width: SCROLL_ITEM_SIZE,
                                    height: SCROLL_ITEM_SIZE,
                                  );
                                else {
                                  final artist = tag.topArtists[index];
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                        margin: EdgeInsets.zero,
                                        child: Material(
                                          shape: CircleBorder(),
                                          clipBehavior: Clip.hardEdge,
                                          color: Colors.transparent,
                                          child: Ink.image(
                                              image: Image.network(
                                                  artist.imageURL)
                                                  .image,
                                              width: SCROLL_ITEM_SIZE,
                                              height: SCROLL_ITEM_SIZE,
                                              fit: BoxFit.cover,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    createPageRoute(
                                                            ArtistPage(
                                                                artist,
                                                                null)),
                                                  );
                                                },
                                              )),
                                        )),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
