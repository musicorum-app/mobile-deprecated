import 'package:musicorum/api/models/tag.dart';
import 'package:musicorum/api/models/image.dart';
import 'package:musicorum/api/models/track_resource.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/api/models/wiki.dart';
import 'package:musicorum/api/musicorum.dart';
import 'package:musicorum/utils/common.dart';
import 'package:musicorum/utils/common.dart';
import 'package:musicorum/utils/common.dart';
import 'package:musicorum/utils/common.dart';

enum TrackType { RECENT_TRACKS, TOP_TRACKS, ALBUM_TRACKS, TRACK_INFO }

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
      this.playCount,
      this.wiki,
      this.tags,
      this.globalPlayCount,
      this.listeners,
      this.resource,
      this.duration,
      this.userLoved = false
      });

  final TrackType type;
  final String name;
  final String album;
  final String artist;
  final LastfmImage images;
  final String url;
  final DateTime streamedAt;
  final int duration;
  final int playCount;
  final int globalPlayCount;
  final int listeners;
  final bool isPlaying;
  final int rank;
  TrackResource resource;
  final bool userLoved;
  final List<Tag> tags;
  final Wiki wiki;

  Future<TrackResource> getResource() async {
    if (resource != null) return resource;
    this.resource = (await MusicorumApi.getTrackResources([
      {'name': this.name, 'artist': this.artist}
    ]))[0];
    return resource;
  }

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
        playCount: int.parse(json['playcount'].toString()));
  }

  factory Track.fromAlbumInfoTracksJSON(
      Map<String, dynamic> json, LastfmImage images) {
    return Track(TrackType.ALBUM_TRACKS,
        name: json['name'],
        artist: json['artist']['name'],
        url: json['url'],
        rank: CommonUtils.parseInt(json['@attr']['rank']),
        images: images);
  }

  factory Track.fromTrackInfoJSON(Map<String, dynamic> json) {
    final bool hasAlbum = json['album'] != null;
    final List images = hasAlbum ? json['album']['image'] as List : null;
    final List _tags = json['toptags']['tag'] as List;
    final Wiki wiki = json['wiki'] != null
        ? Wiki.fromJSONWithoutURL(json['wiki'], json['url'] + '/+wiki')
        : null;

    print(images);

    return Track(TrackType.TRACK_INFO,
        name: json['name'],
        url: json['url'],
        duration: CommonUtils.parseInt(json['duration']),
        listeners: CommonUtils.parseInt(json['listeners']),
        playCount: CommonUtils.parseInt(json['userplaycount']),
        globalPlayCount: CommonUtils.parseInt(json['playcount']),
        artist: json['artist']['name'],
        album: hasAlbum ? json['album']['title'] : null,
        images: hasAlbum
            ? LastfmImage.fromArray(
                images.map((el) => el['#text']).toList().cast<String>(),
                ImageType.TRACK)
            : null,
        userLoved: json['userloved'] == '1',
        tags: _tags.map((t) => Tag(t['name'], t['url'])).toList(),
        wiki: wiki);
  }
}
