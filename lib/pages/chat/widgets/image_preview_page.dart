import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
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
                CustomWidgets.buildLoading(context);
                final response = await get(Uri.parse(arguments.toString()));
                Uint8List bodyBytes = response.bodyBytes;

                await ImageGallerySaver.saveImage(bodyBytes);
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Image Saved");
              } catch (e) {
                Fluttertoast.showToast(msg: "Error ");
                return;
              }
            },
            icon: const Icon(Icons.save),
          ),
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
