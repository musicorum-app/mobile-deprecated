import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/image.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/utils/common.dart';

class User {
  User(this.playCount, this.name, this.username, this.url, this.country,
      this.images, this.registered);

  final int playCount;
  final name;
  final username;
  final url;
  final country;
  final LastfmImage images;
  final int registered;

  List<Artist> topArtists;
  List<Album> topAlbums;
  List<Track> topTracks;

  Future<List<Artist>> getTopArtists(
      {bool force = false, Period period = Period.OVERALL}) async {
    if (!force && topArtists != null) return topArtists;

    topArtists = await LastfmAPI.getTopArtists(username, period);
    return topArtists;
  }

  Future<List<Album>> getTopAlbums(
      {bool force = false, Period period = Period.OVERALL}) async {
    if (!force && topAlbums != null) return topAlbums;

    topAlbums = await LastfmAPI.getTopAlbums(username, period);
    return topAlbums;
  }

  Future<List<Track>> getTopTracks(
      {bool force = false, Period period = Period.OVERALL}) async {
    if (!force && topTracks != null) return topTracks;

    topTracks = await LastfmAPI.getTopTracks(username, period);
    return topTracks;
  }

  DateTime getRegisteredDate() {
    return DateTime.fromMillisecondsSinceEpoch(this.registered * 1000);
  }

  String get displayName {
    return this.name != null && this.name != '' ? this.name : this.username;
  }

  factory User.fromJSON(Map<String, dynamic> json) {
    final List images = json['image'] as List;

    return User(
        CommonUtils.parseInt(json['playcount']),
        json['realname'],
        json['name'],
        json['url'],
        json['country'],
        LastfmImage.fromArray(
            images.map((el) => el['#text']).toList().cast<String>(),
            ImageType.USER),
        int.parse(json['registered']['unixtime']));
  }

  factory User.fromFriendsJSON(Map<String, dynamic> json) {
    final List images = json['image'] as List;

    return User(
        null,
        json['realname'],
        json['name'],
        json['url'],
        json['country'],
        LastfmImage.fromArray(
            images.map((el) => el['#text']).toList().cast<String>(),
            ImageType.USER),
        int.parse(json['registered']['unixtime']));
  }

  factory User.fromSample() {
    return User(
        37583,
        '',
        'MysteryMS',
        'https://www.last.fm/user/MysteryMS',
        'Brazil',
        LastfmImage.fromSingle(
            'https://lastfm.freetls.fastly.net/i/u/300x300/8177311f3f722c96aefc79ac29151b60.png',
            ImageType.USER),
        1586202519);
  }
}
