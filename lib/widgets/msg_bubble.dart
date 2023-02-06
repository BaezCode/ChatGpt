import 'package:bubble/bubble.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageBubble extends StatelessWidget {
  final String de;
  final String para;
  final int tokens;
  final String texto;

  const MessageBubble({
    super.key,
    required this.de,
    required this.para,
    required this.texto,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return de == loginBloc.usuario!.uid
        ? _myMessage(context)
        : _notMyMessage(context);
  }

  Widget _myMessage(context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      color: const Color(0xff21232A).withOpacity(0.8),
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

  Widget _notMyMessage(BuildContext context) {
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
                    Text(
                      texto,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: texto));
                              Fluttertoast.showToast(msg: "Mensaje Copiado");
                            },
                            icon: const Icon(
                              Icons.copy,
                              size: 18,
                              color: Colors.white,
                            )),
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

    /*
    Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: texto));
          Fluttertoast.showToast(msg: "Mensaje Copiado");
        },
        child: Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(left: 2, bottom: 5, right: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bubble(
                  nip: BubbleNip.leftBottom,
                  color: const Color(0xffE4E5E8),
                  child: Text(
                    texto,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "  Used $tokens Tokens",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            )),
      ),
    );
    */
  }
}
