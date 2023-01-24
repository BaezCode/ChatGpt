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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Container(
        child: de == loginBloc.usuario!.uid ? _myMessage() : _notMyMessage(),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 2, bottom: 5, left: 45),
        child: Bubble(
          nip: BubbleNip.rightBottom,
          color: Colors.blue[700],
          child: Text(
            texto,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
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
  }
}
