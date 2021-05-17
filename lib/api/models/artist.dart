import 'package:flutter/cupertino.dart';
import 'package:musicorum/api/models/tag.dart';
import 'package:musicorum/api/models/artist_resource.dart';
import 'package:musicorum/api/models/image.dart';
import 'package:musicorum/api/models/wiki.dart';
import 'package:musicorum/api/musicorum.dart';
import 'package:musicorum/constants/common.dart';

class Artist {
  final String name;
  final String url;
  final int playCount;
  final int globalPlayCount;
  final int listeners;
  ArtistResource resource;
  final List<Tag> tags;
  final List<Artist> similar;
  final Wiki wiki;

  Artist(
      {this.name,
      this.url,
      this.playCount,
      this.resource,
      this.tags,
      this.globalPlayCount,
      this.listeners,
      this.similar,
      this.wiki});

  String get imageURL {
    if (resource != null && resource.image != null && resource.image != '') {
      return resource.image;
    }
    return DEFAULT_ARTIST_IMAGE;
  }

  Future<ArtistResource> getResource() async {
    if (resource != null) return resource;
    this.resource = (await MusicorumApi.getArtistResources([this.name]))[0];
    return resource;
  }

  factory Artist.fromTopArtistsJSON(Map<String, dynamic> json) {
    return Artist(
        name: json['name'],
        url: json['url'],
        playCount: int.parse(json['playcount']));
  }

  factory Artist.fromArtistInfoJSON(Map<String, dynamic> json) {
    final List _tags = json['tags']['tag'] as List;
    final List _similar = json['similar']['artist'] as List;

    return Artist(
      name: json['name'],
      url: json['url'],
      playCount: int.parse(json['stats']['userplaycount']),
      globalPlayCount: int.parse(json['stats']['playcount']),
      listeners: int.parse(json['stats']['listeners']),
      tags: _tags.map((t) => Tag(t['name'], t['url'])).toList(),
      similar:
          _similar.map((a) => Artist(name: a['name'], url: a['url'])).toList(),
      wiki: Wiki.fromJSON(json['bio'])
    );
  }
}
