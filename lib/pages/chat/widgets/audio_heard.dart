import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioHeard extends StatefulWidget {
  const AudioHeard({super.key});

  @override
  State<AudioHeard> createState() => _AudioHeardState();
}

class _AudioHeardState extends State<AudioHeard> {
  late stt.SpeechToText speechToText;
  late ChatBloc chatBloc;
  late LoginBloc loginBloc;
  late ConversacionesBloc conversacionesBloc;

  String _text = 'Press the button and start speaking';
  bool _isListening = false;
  final String defaultLocale =
      Platform.localeName; // Returns locale string in the form 'en_US'

  @override
  void initState() {
    super.initState();
    speechToText = stt.SpeechToText();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        speechToText.listen(
          localeId: defaultLocale,
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.90,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ))
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _text,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarGlow(
                  glowColor: Colors.blue,
                  animate: _isListening,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  endRadius: 75.0,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xff4A78BD),
                    radius: 30,
                    child: IconButton(
                        onPressed: _listen,
                        icon: Icon(
                          _isListening ? CupertinoIcons.xmark : Icons.mic,
                          color: Colors.white,
                          size: 30,
                        )),
                  )),
              if (_isListening == false &&
                  _text != 'Press the button and start speaking') ...[
                CircleAvatar(
                  backgroundColor: const Color(0xff4A78BD),
                  radius: 30,
                  child: IconButton(
                      onPressed: () => submitText(_text),
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                SizedBox(
                  width: size.width * 0.10,
                ),
              ]
            ],
          )
        ],
      ),
    );
  }

  void submitText(String texto) async {
    if (texto.isEmpty && texto == "Press the button and start speaking") return;
    if (loginBloc.state.susActive) {
      Navigator.pop(context);
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
      final resp = await chatBloc.getGP4(texto, loginBloc);
      //  final resp = await chatBloc.getMesaje(texto, loginBloc);
      conversacionesBloc.updateConv(jsonEncode(resp), chatModel.mensaje);
      chatBloc.add(SetEscribiendo(false));
    } else {
      if (loginBloc.usuario!.tokens! <= 35) {
        Fluttertoast.showToast(msg: 'Low Tokens');
      } else {
        Navigator.pop(context);
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
        final resp = await chatBloc.getGP4(texto, loginBloc);
        //  final resp = await chatBloc.getMesaje(texto, loginBloc);
        conversacionesBloc.updateConv(jsonEncode(resp), chatModel.mensaje);
        chatBloc.add(SetEscribiendo(false));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }
}
