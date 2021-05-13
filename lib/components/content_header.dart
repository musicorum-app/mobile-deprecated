import 'package:flutter/material.dart';
import 'package:musicorum/components/rounded_image.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/image_viewer_page.dart';
import 'package:musicorum/utils/common.dart';

const CONTENT_HEADER_IMAGE_FACTOR = 1.3;

class ContentHeader extends StatelessWidget {
  final bool loaded;
  final ImageProvider mainImage;
  final ImageProvider backgroundImage;
  final String name;
  final String secondary;
  final bool squareImage;
  final Function onSecondaryTap;
  final String imageViewURL;
  final Color loadingColor;

  const ContentHeader({@required this.loaded,
    this.mainImage,
    this.backgroundImage,
    this.name,
    this.squareImage = false,
    this.onSecondaryTap,
    this.secondary,
    this.imageViewURL,
    this.loadingColor
  });

  static double getHeaderFractionFromOffset(BuildContext context,
      double scrollOffset) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var appBarHeightLimit = screenWidth * CONTENT_HEADER_IMAGE_FACTOR;
    var appBarHeightMin = screenWidth * 0.9;

    var appBarVisibility = 0.0;

    if (scrollOffset > appBarHeightLimit)
      appBarVisibility = 1.0;
    else if (scrollOffset < appBarHeightMin)
      appBarVisibility = 0.0;
    else
      appBarVisibility = CommonUtils.convertRanges(
          scrollOffset, appBarHeightMin, appBarHeightLimit, 0.0, 1.0);
    return appBarVisibility;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var backgroundImageHeight = screenWidth * CONTENT_HEADER_IMAGE_FACTOR;

    return Container(
      child: Stack(
        children: [
          Container(
              height: backgroundImageHeight,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      height: backgroundImageHeight,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SURFACE_COLOR.withAlpha(90),
                              SURFACE_COLOR
                            ],
                            stops: [0.56, 1],
                            begin: FractionalOffset.topCenter,
                            end: AlignmentDirectional.bottomCenter,
                          )),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: loaded && backgroundImage != null
                    ? DecorationImage(
                  image: Image(
                    image: backgroundImage,
                    height: backgroundImageHeight,
                    width: screenWidth,
                  ).image,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitHeight,
                )
                    : null,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth,
                height: screenWidth * .8,
              ),
              (mainImage != null
                  ? InkWell(
                  child: Container(
                    child: this.squareImage
                        ? RoundedImageProvider(
                      mainImage,
                      width: screenWidth *
                          CONTENT_PAGE_IMAGE_SIZE_FRACTION *
                          2,
                      height: screenWidth *
                          CONTENT_PAGE_IMAGE_SIZE_FRACTION *
                          2,
                      radius: 5,
                    )
                        : CircleAvatar(
                      radius: screenWidth *
                          CONTENT_PAGE_IMAGE_SIZE_FRACTION,
                      backgroundImage: mainImage,
                    ),
                    decoration: BoxDecoration(
                        shape: this.squareImage
                            ? BoxShape.rectangle
                            : BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Color(0x70000000),
                              spreadRadius: 2)
                        ]),

                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageViewerPage(Image.network(imageViewURL).image, imageViewURL, loadingColor, name),
                      ),
                    );
                  },
              )
                  : Container()),
              SizedBox(
                height: 10,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              (secondary != null
                  ? Column(
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  InkWell(
                    borderRadius:
                    new BorderRadius.all(Radius.circular(4.0)),
                    onTap: onSecondaryTap,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        secondary,
                        style: TextStyle(
                            color: SURFACE_SECONDARY_TEXT_COLOR,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              )
                  : Column())
            ],
          )
        ],
      ),
    );
  }
}
