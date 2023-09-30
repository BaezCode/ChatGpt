import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
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
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: texto));
        Fluttertoast.showToast(msg: "Copied To Clipboard");
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(right: 5, bottom: 5, left: 5),
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
          child: Text(
            texto,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget _notMyMessage(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: texto));
        Fluttertoast.showToast(msg: "Copied");
      },
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(right: 5, bottom: 5, left: 5),
                decoration: BoxDecoration(
                    color: const Color(0xfff20262e),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  texto,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: texto));
                        Fluttertoast.showToast(msg: "Copied");
                      },
                      icon: const Icon(
                        Icons.copy,
                        size: 20,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () async {
                        await FlutterShare.share(
                          title: 'Share',
                          text: texto,
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.share,
                        size: 20,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 25,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
