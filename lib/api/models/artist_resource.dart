import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/musicorum.dart';

class ArtistResource {
  ArtistResource({this.name, this.hash, this.spotify, this.image});

  final String name;
  final String hash;
  final String spotify;
  final String image;

  factory ArtistResource.fromJSON(Map<String, dynamic> json) {
    return ArtistResource(
      hash: json['hash'],
      image: json['image'],
      name: json['name'],
      spotify: json['spotify']
    );
  }

  static Future<void> getResources(List<Artist> artists) async {
    List<String> names = [];

    for(var i = 0; i < artists.length; i++) {
      Artist artist = artists[i];
      if (artist.resource != null) continue;
      names.add(artist.name);
    }

    var resources = await MusicorumApi.getArtistResources(names);

    for(var i = 0; i < resources.length; i++) {
      ArtistResource resource = resources[i];
      if (resource == null) continue;
      artists[i].resource = resource;
    }
  }
}