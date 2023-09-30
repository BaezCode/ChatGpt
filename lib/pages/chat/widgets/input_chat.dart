import 'dart:convert';

import 'package:chat_gpt/bloc/action/action_bloc.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/pages/chat/widgets/audio_heard.dart';
import 'package:chat_gpt/pages/chat/widgets/variation.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class InputChat extends StatefulWidget {
  const InputChat({super.key});

  @override
  State<InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<InputChat> {
  final _textController = TextEditingController();
  late ChatBloc chatBloc;
  late LoginBloc loginBloc;
  late PagosBloc pagosBloc;
  late ConversacionesBloc conversacionesBloc;

  final prefs = PreferenciasUsuario();
  bool textoEscrito = false;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.escribiendo) _variation(state.modo),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                      height: 50,
                      width: size.width - 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: Center(
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        textoEscrito = false;
                                      });
                                    } else {
                                      setState(() {
                                        textoEscrito = true;
                                      });
                                    }
                                  },
                                  onEditingComplete:
                                      () {}, // this prevents keyboard from closing
                                  controller: _textController,
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: null,
                                  decoration: InputDecoration.collapsed(
                                      fillColor: Colors.white,
                                      hintText: resp.send,
                                      hintStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          _sendButton(state)
                        ],
                      )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _sendButton(ChatState state) {
    return textoEscrito == false && state.modo == 0
        ? IconButton(
            splashColor: Colors.transparent,
            onPressed: state.escribiendo
                ? null
                : () {
                    showModalBottomSheet(
                        backgroundColor: Color(0xfff20262e),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        isScrollControlled: true,
                        context: context,
                        builder: (bc) {
                          return const SafeArea(child: AudioHeard());
                        });
                  },
            icon: const Icon(
              Icons.mic,
              color: Colors.white,
            ))
        : IconButton(
            splashColor: Colors.transparent,
            onPressed: state.escribiendo
                ? null
                : () => submitText(_textController.text.trim()),
            icon: const Icon(
              CupertinoIcons.location_fill,
              color: Colors.white,
              size: 20,
            ));
  }

  Widget _variation(int modo) {
    final resp = AppLocalizations.of(context)!;

    switch (modo) {
      case 0:
        return TextVariation(texto: resp.tipping);
      case 1:
        return TextVariation(texto: resp.tippingImage);
      case 3:
        return TextVariation(texto: resp.variationWait);
      default:
        return TextVariation(texto: resp.tipping);
    }
  }

  void submitText(String texto) async {
    if (texto.isEmpty) return;
    setState(() {
      textoEscrito = false;
    });
    if (loginBloc.usuario!.tokens! <= 35 &&
        loginBloc.state.susActive == false) {
      Fluttertoast.showToast(msg: 'Low Tokens');
    } else {
      _textController.clear();
      final chatModel = ChatModel(
          de: loginBloc.usuario!.uid,
          para: loginBloc.usuario!.idAssist,
          list: [],
          tokens: 0,
          mensaje: texto,
          dateTime: DateTime.now().millisecondsSinceEpoch,
          tipo: 0);
      chatBloc.addChats(chatModel);
      chatBloc.add(SetEscribiendo(true));
      //  final resp = await chatBloc.getGP4(texto, loginBloc);
      final resp = await chatBloc.getMesaje(texto, loginBloc);
      conversacionesBloc.updateConv(jsonEncode(resp), chatModel.mensaje);
      chatBloc.add(SetEscribiendo(false));
    }
  }
}
