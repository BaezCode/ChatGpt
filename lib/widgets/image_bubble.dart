import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageBubble extends StatelessWidget {
  final String texto;
  final String de;
  final int tokens;

  final String para;

  const ImageBubble(
      {super.key,
      required this.texto,
      required this.de,
      required this.para,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return de == loginBloc.usuario!.uid
        ? _myMessage(context)
        : _notMyMesage(context);
  }

  Widget _myMessage(context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      color: const Color(0xff21232A).withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: const Color(0xff21232A).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                width: 40,
                child: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 30,
                )),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width * 0.80,
              child: Text(
                texto,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notMyMesage(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: const Color(0xff424549).withOpacity(0.8),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xff21232A),
                  borderRadius: BorderRadius.circular(10)),
              width: 40,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: size.width * 0.80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                          arguments: texto),
                      child: Container(
                          padding: const EdgeInsets.all(5.0),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'assets/images/loading.gif',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                imageUrl: texto),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text("Create Variation")),
                        Text(
                          "  Used $tokens Tokens",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
