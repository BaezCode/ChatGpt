import 'dart:convert';

import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class ImageBubble extends StatelessWidget {
  final String texto;
  final String de;
  final int tokens;
  final String para;
  final List<dynamic> lista;

  const ImageBubble({
    super.key,
    required this.texto,
    required this.de,
    required this.para,
    required this.tokens,
    required this.lista,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return de == loginBloc.usuario!.uid
        ? _myMessage(context)
        : _notMyMesage(context, loginBloc);
  }

  Widget _myMessage(context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: texto));
        Fluttertoast.showToast(msg: "Copied");
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(right: 5, bottom: 5, left: 5),
          decoration: BoxDecoration(
              color: const Color(0xff21232A),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            texto,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _notMyMesage(BuildContext context, LoginBloc loginBloc) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final data = AppLocalizations.of(context)!;
    final image = base64Decode(texto);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(right: 5, bottom: 5, left: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                        arguments: base64Decode(texto)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: Image(
                              gaplessPlayback: true, image: MemoryImage(image)),
                        ))),
                if (lista.isEmpty && state.escribiendo == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () async {
                            /*
                            chatBloc.add(SetModo(3));
                            chatBloc.add(SetEscribiendo(true));
                            final resp = await chatBloc.getImagesVariation(
                                texto, loginBloc);
                            if (resp.isNotEmpty) {
                              chatBloc.add(SetEscribiendo(false));
                              chatBloc.add(SetModo(2));
                              conversacionesBloc.updateConv(
                                  jsonEncode(resp), "Image");
                            } else {
                              chatBloc.add(SetEscribiendo(false));
                              chatBloc.add(SetModo(2));

                              Fluttertoast.showToast(msg: 'Error Try Again');
                            }
                            */
                          },
                          child: Text(data.variation)),
                      Text(
                        "  Used $tokens Tokens",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                if (lista.isNotEmpty) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  _imageVariation(context)
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageVariation(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                    arguments: base64Decode(lista[0]['b64_json'])),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image(
                          gaplessPlayback: true,
                          image:
                              MemoryImage(base64Decode(lista[0]['b64_json']))),
                    ))),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                  arguments: base64Decode(lista[1]['b64_json'])),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(
                        gaplessPlayback: true,
                        image: MemoryImage(base64Decode(lista[1]['b64_json']))),
                  )),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "  Used $tokens Tokens",
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        )
      ],
    );
  }
}
