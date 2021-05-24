import 'package:flutter/material.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/colored_card.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/components/skeleton/skeleton_box.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/states/login.dart';
import 'package:musicorum/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChartsPersonalView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChartsPersonalViewState();
}

class _ChartsPersonalViewState extends State<ChartsPersonalView> {
  User user;

  Color artistColor;
  Color albumColor;
  Color trackColor;

  @override
  void initState() {
    super.initState();
    _fetchStuff(force: false);
  }

  Future<void> _fetchStuff({bool force = true}) async {
    user = Provider.of<AuthState>(context, listen: false).user;
    print(user);
    print('fetching charts');
    await Future.wait([
      user.getTopArtists(force: force),
      user.getTopAlbums(force: force),
      user.getTopTracks(force: force),
    ]);
    await user.topArtists[0].getResource();
    await user.topTracks[0].getResource();
    setState(() {});
    _handleColors();
  }

  _handleColors() async {
    artistColor = await CommonUtils.getDarkPredominantColorFromImageProvider(
        Image.network(user.topArtists[0].resource.image).image);
    albumColor = await CommonUtils.getDarkPredominantColorFromImageProvider(
        user.topAlbums[0].images.getLargeImage().image);
    trackColor = await CommonUtils.getDarkPredominantColorFromImageProvider(
        Image.network(user.topTracks[0].resource.image).image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
          children: [
            SizedBox(
              height: LIST_PADDING,
            ),
            _ChartCard(
              loaded: user != null && user.topArtists != null,
              title: 'Artists',
              amount: 200,
              image: user != null && user.topArtists != null
                  ? Image.network(user.topArtists[0].imageURL).image
                  : null,
              mainColor: artistColor,
            ),
            SizedBox(
              height: 10,
            ),
            _ChartCard(
              loaded: user != null && user.topAlbums != null,
              title: 'Albums',
              amount: 200,
              image: user != null && user.topAlbums != null
                  ? user.topAlbums[0].images.getLargeImage().image
                  : null,
              mainColor: albumColor,
            ),
            SizedBox(
              height: 10,
            ),
            _ChartCard(
              loaded: user != null && user.topTracks != null,
              title: 'Tracks',
              amount: 200,
              image: user != null && user.topTracks != null
                  ? Image.network(user.topTracks[0].resource.image).image
                  : null,
              mainColor: trackColor,
            ),
            SizedBox(
              height: LIST_PADDING,
            ),
          ],
        ),
        onRefresh: _fetchStuff);
  }
}

class _ChartCard extends StatelessWidget {
  _ChartCard(
      {@required this.loaded,
      this.amount,
      this.title,
      this.image,
      this.mainColor});

  final bool loaded;
  final double _height = 120;
  final int amount;
  final String title;
  final ImageProvider image;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    if (!loaded)
      return Container(
        child: Shimmer.fromColors(
            baseColor: PLACEHOLDER_COLOR,
            highlightColor: PLACEHOLDER_PULSE_COLOR,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  color: Colors.white),
              height: _height,
            )),
      );
    return Ink(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
          gradient: ColoredCard.createGradient(mainColor)),
      height: _height,
      child: InkWell(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 30.0,
                        )
                      ],
                    ),
                    Text(
                      amount.toString(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xBBFFFFFF)),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: 3.0,
                      blurRadius: 4.0)
                ]),
                child: RoundedImageProvider(
                  image,
                  radius: BORDER_RADIUS,
                ),
              )
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
