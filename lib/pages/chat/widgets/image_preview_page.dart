import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
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
              try {
                var imageId =
                    await ImageDownloader.downloadImage(arguments.toString());
                if (imageId == null) {
                  return;
                }
                Fluttertoast.showToast(msg: "Imagen Guardada Correctamente");
              } on PlatformException catch (error) {
                Fluttertoast.showToast(msg: "Error Intente de Nuevo");
              }
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
