import 'package:flutter/services.dart';

class MiscConnections {
  static const methodChannel = const MethodChannel('com.musicorumapp.mobile.musicorum/misc');

  static Future<String> getVersionString() async {
    String version;

    try {
      version = await methodChannel.invokeMethod('getVersionString');
    } on PlatformException catch (e) {
      print(e);
      version = 'Could not get version information.';
    }

    return version;
  }
}