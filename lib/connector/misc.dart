import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MiscConnections {
  static const methodChannel = const MethodChannel(
      'com.musicorumapp.mobile.musicorum/misc');

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

class ColorPalette {
  ColorPalette({
    this.darkMuted,
    this.darkVibrant,
    this.lightMuted,
    this.lightVibrant,
    this.muted,
    this.vibrant
  });

  final Color lightVibrant;
  final Color vibrant;
  final Color darkVibrant;
  final Color lightMuted;
  final Color muted;
  final Color darkMuted;
}