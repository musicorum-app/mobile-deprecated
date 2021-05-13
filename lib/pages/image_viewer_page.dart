import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage(this.image, this.imageURL, this._color, this.name);

  final ImageProvider image;
  final Color _color;
  final String name;
  final String imageURL;

  Color get color {
    return _color != null
        ? _color.toTinyColor().brighten(30).color
        : Colors.white;
  }

  _shareImage() async {
    var request = await HttpClient().getUrl(Uri.parse(imageURL));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file(name, '$name.png', bytes, 'image/png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.35),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share image',
            onPressed: () {
              _shareImage();
            },
          ),
        ],
      ),
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        enableRotation: false,
        loadingBuilder: (context, event) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: LinearProgressIndicator(
              value: event == null
                  ? null
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: color.withOpacity(.3),
            ),
          ),
        ),
        imageProvider: image,
      ),
    );
  }
}
