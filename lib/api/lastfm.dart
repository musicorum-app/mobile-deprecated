import 'dart:async';
import 'dart:convert';

import 'package:musicorum/api/models/album.dart';
import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/types.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/constants/common.dart';
import 'package:http/http.dart';

class LastfmAPI {
  static Future<Map<String, dynamic>> doGet(
      String method, Map<String, String> parameters) async {
    parameters['format'] = 'json';
    parameters['method'] = method;
    parameters['api_key'] = LASTFM_KEY;

    String params = Uri(queryParameters: parameters).query;

    String url = '$LASTFM_API_URL?$params';

    print('DOING REQUEST TO $url');

    Response response = await get(url);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static Future<List<Track>> getRecentTracks(String user) async {
    var body = await LastfmAPI.doGet('user.getRecentTracks', {'user': user});

    final List tracks = body['recenttracks']['track'] as List;

    return tracks.map((t) => Track.fromRecentScrobblesJSON(t)).toList();
  }

  static Future<List<Track>> getTopTracks(String user, Period period) async {
    var body = await LastfmAPI.doGet('user.getTopTracks', {
      'user': user,
      'period': period.name
    });

    final List tracks = body['toptracks']['track'] as List;

    return tracks.map((t) => Track.fromTopTracksJSON(t)).toList();
  }

  static Future<List<Album>> getTopAlbums(String user, Period period) async {
    var body = await LastfmAPI.doGet('user.getTopAlbums', {
      'user': user,
      'period': period.name
    });

    final List albums = body['topalbums']['album'] as List;

    return albums.map((t) => Album.fromTopAlbumsJSON(t)).toList();
  }

  static Future<List<Artist>> getTopArtists(String user, Period period) async {
    var body = await LastfmAPI.doGet('user.getTopArtists', {
      'user': user,
      'period': period.name
    });

    final List albums = body['topartists']['artist'] as List;

    return albums.map((t) => Artist.fromTopArtistsJSON(t)).toList();
  }

  static Future<List<User>> getFriends(String user) async {
    var body = await LastfmAPI.doGet('user.getFriends', {
      'user': user
    });

    final List friends = body['friends']['user'] as List;

    return friends.map((t) => User.fromFriendsJSON(t)).toList();
  }

  static Future<List<Album>> getArtistTopAlbums(String artist) async {
    var body = await LastfmAPI.doGet('artist.getTopAlbums', {
      'artist': artist
    });

    final List friends = body['topalbums']['album'] as List;

    return friends.map((t) => Album.fromArtistTopAlbums(t)).toList();
  }

  static Future<Artist> getArtistInfo(String artist, String user) async {
    var body = await LastfmAPI.doGet('artist.getInfo', {
      'artist': artist,
      'username': user
    });

    return Artist.fromArtistInfoJSON(body['artist']);
  }

  static Future<List<Track>> getArtistTopTracks(String artist) async {
    var body = await LastfmAPI.doGet('artist.getTopTracks', {
      'artist': artist,
    });

    final List tracks = body['toptracks']['track'] as List;

    return tracks.map((t) => Track.fromTopTracksJSON(t)).toList();
  }

  static Future<Album> getAlbumInfo(String album, String artist, String user) async {
    var body = await LastfmAPI.doGet('album.getInfo', {
      'artist': artist,
      'username': user,
      'album': album
    });

    return Album.fromAlbumInfoJSON(body['album']);
  }

  static Future<User> getUserInfo(String user) async {
    var body = await LastfmAPI.doGet('user.getInfo', {
      'user': user
    });

    return User.fromJSON(body);
  }

  static Future<Track> getTrackInfo(String name, String artist, String user) async {
    var body = await LastfmAPI.doGet('track.getInfo', {
      'artist': artist,
      'username': user,
      'track': name
    });

    return Track.fromTrackInfoJSON(body['track']);
  }

  static Future<List<Track>> getTracksSimilar(String name, String artist) async {
    var body = await LastfmAPI.doGet('track.getSimilar', {
      'track': name,
      'artist': artist,
    });

    print(body);

    final List tracks = body['similartracks']['track'] as List;

    return tracks.map((t) => Track.fromTopTracksJSON(t)).toList();
  }
}
