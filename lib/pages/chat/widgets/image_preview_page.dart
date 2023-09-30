import 'dart:typed_data';

import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? Uint8List);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xff21232A),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                CustomWidgets.buildLoading(context);

                await ImageGallerySaver.saveImage(arguments as Uint8List);
                // ignore: use_build_context_synchronously
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
            child: Image.memory(arguments as Uint8List)),
      ),
    );
  }
}
