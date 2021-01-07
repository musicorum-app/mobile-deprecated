import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/musicorum.dart';

class TrackResource {
  TrackResource(
      {this.hash,
      this.name,
      this.album,
      this.artist,
      this.spotify,
      this.image,
      this.duration,
      this.preview});

  final String hash;
  final String name;
  final String artist;
  final String album;
  final String spotify;
  final String image;
  final String preview;
  final int duration;

  factory TrackResource.fromJSON(Map<String, dynamic> json) {
    return TrackResource(
        hash: json['hash'],
        image: json['cover'],
        name: json['name'],
        spotify: json['spotify'],
        artist: json['artist'],
        album: json['album'],
        duration: json['duration'],
        preview: json['preview']);
  }

  static Future<void> getResources(List<Track> tracks) async {
    List<Map<String, String>> toFetch = [];

    for (var i = 0; i < tracks.length; i++) {
      Track track = tracks[i];
      if (track.resource != null) continue;
      toFetch.add({
        'name': track.name,
        'artist': track.artist
      });
    }

    var resources = await MusicorumApi.getTrackResources(toFetch);

    for (var i = 0; i < resources.length; i++) {
      TrackResource resource = resources[i];
      if (resource == null) continue;
      tracks[i].resource = resource;
    }
  }
}
