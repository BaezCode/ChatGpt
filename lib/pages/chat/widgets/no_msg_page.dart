import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class NoMsgPage extends StatefulWidget {
  final ChatState state;
  const NoMsgPage({super.key, required this.state});

  @override
  State<NoMsgPage> createState() => _NoMsgPageState();
}

class _NoMsgPageState extends State<NoMsgPage> {
  late ChatBloc chatBloc;
  late LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return widget.state.modo == 0 ? _exampleTest(resp) : _imageMode(resp);
  }

  Widget _exampleTest(AppLocalizations resp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        const Icon(
          Icons.text_fields_outlined,
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(resp.consult,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            )),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => _text(resp.consult2),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xff21232A),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                resp.consult2,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => _text(resp.consult3),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xff21232A),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                resp.consult3,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageMode(AppLocalizations resp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        const Icon(
          Icons.image,
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(resp.consult,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            )),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => _image(resp.consult4),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xff21232A),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                resp.consult4,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => _image(resp.consult5),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff21232A),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                resp.consult5,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _image(String texto) async {
    final chatModel = ChatModel(
        de: loginBloc.usuario!.uid,
        para: loginBloc.usuario!.idAssist,
        tokens: 0,
        mensaje: texto,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        tipo: 1);
    chatBloc.addChats(chatModel);
    chatBloc.add(SetEscribiendo(true));
    await chatBloc.getImage(texto, loginBloc);
    chatBloc.add(SetEscribiendo(false));
  }

  void _text(String texto) async {
    final chatModel = ChatModel(
        de: loginBloc.usuario!.uid,
        para: loginBloc.usuario!.idAssist,
        tokens: 0,
        mensaje: texto,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        tipo: 0);
    chatBloc.addChats(chatModel);

    chatBloc.add(SetEscribiendo(true));
    await chatBloc.getMesaje(texto, loginBloc);
    chatBloc.add(SetEscribiendo(false));
  }
}
