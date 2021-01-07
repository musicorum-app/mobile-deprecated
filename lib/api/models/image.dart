import 'package:flutter/material.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/constants/common.dart';

final DEFAULT_USER = Image.network(DEFAULT_AVATAR_IMAGE);
final DEFAULT_TRACK = Image.network(DEFAULT_TRACK_IMAGE);
final DEFAULT_ALBUM = Image.network(DEFAULT_ALBUM_IMAGE);
final DEFAULT_ARTIST = Image.network(DEFAULT_ARTIST_IMAGE);

class LastfmImage {
  LastfmImage(this.small, this.medium, this.large, this.extraLarge, this.type);

  final ImageType type;

  final String small;
  final String medium;
  final String large;
  final String extraLarge;

  get defaultImage {
    if (type == ImageType.USER) return DEFAULT_USER;
    if (type == ImageType.TRACK) return DEFAULT_TRACK;
    if (type == ImageType.ALBUM) return DEFAULT_ALBUM;
    if (type == ImageType.ARTIST) return DEFAULT_ARTIST;
  }

  get defaultImageURL {
    print(type);
    if (type == ImageType.USER) return DEFAULT_AVATAR_IMAGE;
    if (type == ImageType.TRACK) return DEFAULT_TRACK_IMAGE;
    if (type == ImageType.ALBUM) return DEFAULT_ALBUM_IMAGE;
    if (type == ImageType.ARTIST) return DEFAULT_ARTIST_IMAGE;
  }

  get isNull {
    return medium == '';
  }

  String getImageURLFromSize(int width, [int height]) {
    if (height == null) height = width;
    if (this.isNull) return this.defaultImageURL;
    return this.extraLarge.replaceAll('/300x300/', '/${width}x$height/');
  }

  Image getImageFromSize(int size) {
    if (this.isNull) return this.defaultImage;
    return Image.network(this.extraLarge.replaceAll('/300x300/', '/${size}x$size/'));
  }

  Image getSmallImage() {
    if (this.isNull) return this.defaultImage;
    return Image.network(small);
  }

  Image getMediumImage() {
    if (this.isNull) return this.defaultImage;
    return Image.network(medium);
  }

  Image getLargeImage() {
    if (this.isNull) return this.defaultImage;
    return Image.network(large);
  }

  Image getExtraLargeImage() {
    if (this.isNull) return this.defaultImage;
    return Image.network(extraLarge);
  }

  factory LastfmImage.fromArray(List<String> images, ImageType type) {
    return LastfmImage(images[0], images[1], images[2], images[3], type);
  }

  factory LastfmImage.fromSingle(String img, ImageType type) {
    return LastfmImage(img, img, img, img, type);
  }
}