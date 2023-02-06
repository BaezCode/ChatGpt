import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'ImagePreview', arguments: texto),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.only(left: 2, bottom: 5, right: 45),
                child: Bubble(
                    nip: BubbleNip.leftBottom,
                    color: const Color(0xffE4E5E8),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                              'assets/images/loading.gif',
                              fit: BoxFit.cover,
                            ),
                        imageUrl: texto)),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "     Used $tokens Tokens",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          )),
    );
  }
}
