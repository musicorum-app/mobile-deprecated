import 'dart:convert';

import 'package:http/http.dart';
import 'package:musicorum/api/models/artist_resource.dart';
import 'package:musicorum/api/models/track_resource.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/constants/common.dart';

class MusicorumApi {
  static Future<User> getAccountFromToken(String token) async {
    final String url = '$MUSICORUM_API_URL/auth/me';
    final Map<String, String> headers = {"Authorization": token};
    Response response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      return User.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      int code = response.statusCode;
      print('Error on API: Error code $code');
      throw Error();
    }
  }

  static Future<List<ArtistResource>> getArtistResources(
      List<String> artists) async {
    final String url = '$MUSICORUM_RESOURCE_URL/find/artists';

    Response response = await post(url,
        body: jsonEncode(<String, dynamic>{'artists': artists}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      return (jsonDecode(utf8.decode(response.bodyBytes)) as Iterable)
          .map((a) => a == null ? null : ArtistResource.fromJSON(a))
          .toList();
    } else {
      int code = response.statusCode;
      print('Error on API: Error code $code');
      throw Error();
    }
  }

  static Future<List<TrackResource>> getTrackResources(
      List<Map<String, String>> albums) async {
    final String url = '$MUSICORUM_RESOURCE_URL/find/tracks';

    Response response = await post(url,
        body: jsonEncode(<String, dynamic>{'tracks': albums}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    print(jsonDecode(utf8.decode(response.bodyBytes)));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Iterable)
          .map((a) => a == null ? null : TrackResource.fromJSON(a))
          .toList();
    } else {
      int code = response.statusCode;
      print('Error on API: Error code $code');
      throw Error();
    }
  }
}
