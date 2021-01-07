import 'package:musicorum/api/models/image.dart';
import 'package:musicorum/api/models/track_resource.dart';
import 'package:musicorum/api/models/types.dart';

enum TrackType { RECENT_TRACKS, TOP_TRACKS, ALBUM_TRACKS }

class Track {
  Track(this.type,
      {this.name,
      this.album,
      this.artist,
      this.images,
      this.url,
      this.streamedAt,
      this.isPlaying = false,
      this.rank,
      this.playCount});

  final TrackType type;
  final String name;
  final String album;
  final String artist;
  final LastfmImage images;
  final String url;
  final DateTime streamedAt;
  final int playCount;
  final bool isPlaying;
  final int rank;
  TrackResource resource;

  factory Track.fromRecentScrobblesJSON(Map<String, dynamic> json) {
    final List images = json['image'] as List;

    bool isListening = false;
    if (json['@attr'] != null && json['@attr']['nowplaying'] == 'true') {
      isListening = true;
    }

    return Track(TrackType.RECENT_TRACKS,
        name: json['name'],
        album: json['album']['#text'],
        artist: json['artist']['#text'],
        url: json['url'],
        images: LastfmImage.fromArray(
            images.map((el) => el['#text']).toList().cast<String>(),
            ImageType.TRACK),
        streamedAt: isListening
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                int.parse(json['date']['uts']) * 1000,
                isUtc: true),
        isPlaying: isListening);
  }

  factory Track.fromTopTracksJSON(Map<String, dynamic> json) {
    final List images = json['image'] as List;

    return Track(TrackType.TOP_TRACKS,
        name: json['name'],
        artist: json['artist']['name'],
        url: json['url'],
        images: LastfmImage.fromArray(
            images.map((el) => el['#text']).toList().cast<String>(),
            ImageType.TRACK),
        playCount: int.parse(json['playcount']));
  }

  factory Track.fromAlbumInfoTracksJSON(
      Map<String, dynamic> json, LastfmImage images) {
    return Track(TrackType.ALBUM_TRACKS,
        name: json['name'],
        artist: json['artist']['name'],
        url: json['url'],
        rank: int.parse(json['@attr']['rank']),
        images: images);
  }
}
