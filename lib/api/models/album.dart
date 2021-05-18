import 'package:musicorum/api/models/tag.dart';
import 'package:musicorum/api/models/image.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/api/models/wiki.dart';

enum AlbumType { TOP_ALBUMS, ALBUM_INFO }

class Album {
  Album(this.type,
      {this.name,
      this.artist,
      this.images,
      this.url,
      this.playCount,
      this.listeners,
      this.globalPlayCount,
      this.wiki,
      this.tracks,
      this.tags});

  final AlbumType type;
  final String name;
  final String artist;
  final LastfmImage images;
  final String url;
  final int playCount;
  final int globalPlayCount;
  final int listeners;
  final Wiki wiki;
  final List<Track> tracks;
  final List<Tag> tags;

  factory Album.fromTopAlbumsJSON(Map<String, dynamic> json) {
    final List images = json['image'] as List;

    return Album(AlbumType.TOP_ALBUMS,
        name: json['name'],
        artist: json['artist']['name'],
        url: json['url'],
        images: LastfmImage.fromArray(
            images.map((el) => el['#text']).toList().cast<String>(),
            ImageType.ALBUM),
        playCount: int.parse(json['playcount']));
  }

  factory Album.fromArtistTopAlbums(Map<String, dynamic> json) {
    final List images = json['image'] as List;

    return Album(AlbumType.TOP_ALBUMS,
        name: json['name'],
        artist: json['artist']['name'],
        url: json['url'],
        images: LastfmImage.fromArray(
            images.map((el) => el['#text']).toList().cast<String>(),
            ImageType.ALBUM),
        globalPlayCount: json['playcount']);
  }

  factory Album.fromAlbumInfoJSON(Map<String, dynamic> json) {
    print(json);
    final List images = json['image'] as List;
    final List _tags = json['tags']['tag'] as List;
    final List tracks = json['tracks']['track'] as List;
    LastfmImage lfmImages = LastfmImage.fromArray(
        images.map((el) => el['#text']).toList().cast<String>(),
        ImageType.ALBUM);

    return Album(
      AlbumType.ALBUM_INFO,
      name: json['name'],
      artist: json['artist'],
      url: json['url'],
      images: lfmImages,
      playCount: json['userplaycount'],
      globalPlayCount: int.parse(json['playcount']),
      listeners: int.parse(json['listeners']),
      wiki: json['wiki'] != null ? Wiki.fromJSONWithoutURL(json['wiki'], json['url'] + '/+wiki') : null,
      tracks: tracks
          .map((t) => Track.fromAlbumInfoTracksJSON(t, lfmImages))
          .toList(),
      tags: _tags.map((t) => Tag(t['name'], t['url'])).toList(),
    );
  }
}
