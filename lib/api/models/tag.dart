import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/wiki.dart';

class Tag {
  Tag(this.name, this.url);

  final String name;
  final String url;
  Wiki wiki;
  int total;
  int reach;
  List<Artist> topArtists;
  List<Tag> similar;

  Future<void> fetchInfo() async {
    final info = await LastfmAPI.getTagInfo(name);
    wiki = Wiki(
      published: '-',
      summary: info['wiki']['summary'],
      content: info['wiki']['content'],
      url: url
    );
    total = info['total'];
    reach = info['reach'];
  }

  Future<List<Tag>> fetchSimilar() async {

  }

  Future<List<Artist>> fetchTopArtists() async {
    topArtists = await LastfmAPI.getTagTopArtists(name, 10, 1);
    return topArtists;
  }
}