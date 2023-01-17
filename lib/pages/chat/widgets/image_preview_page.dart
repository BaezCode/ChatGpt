import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? String);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xff21232A),
        actions: [
          IconButton(
            onPressed: () async {
              final resp = await GallerySaver.saveImage(arguments.toString());
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              ))
        ],
        title: const Text("Image Preview"),
      ),
      body: Center(
        child: PinchZoom(
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 2.5,
            child: CachedNetworkImage(imageUrl: arguments.toString())),
      ),
    );
  }
}
