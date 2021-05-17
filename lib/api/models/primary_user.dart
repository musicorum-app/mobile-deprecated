import 'package:musicorum/api/models/track.dart';
import 'package:musicorum/api/models/user.dart';

class PrimaryUser {
  PrimaryUser(
      this.baseUser, this.recentScrobbles
      );

  final User baseUser;
  final List<Track> recentScrobbles;
}