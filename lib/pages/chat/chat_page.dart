import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/pages/chat/widgets/drawer_home.dart';
import 'package:chat_gpt/pages/chat/widgets/input_chat.dart';
import 'package:chat_gpt/pages/chat/widgets/no_msg_page.dart';
import 'package:chat_gpt/pages/chat/widgets/robot_chat.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:chat_gpt/widgets/image_bubble.dart';
import 'package:chat_gpt/widgets/msg_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helper/customWidgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final prefs = PreferenciasUsuario();
  late ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          drawer: const DrawerHome(),
          backgroundColor: const Color(0xff424549),
          appBar: AppBar(
            title: Text(
              state.modo == 0 ? "Modo Texto" : "Modo Imagen",
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (state.modo == 0) {
                    chatBloc.clearData();
                    chatBloc.add(SetModo(1));
                    if (prefs.vistoImagen == false) {
                      CustomWidgets.crearBuildImage(context);
                    }
                  } else {
                    chatBloc.clearData();
                    chatBloc.add(SetModo(0));
                  }
                },
                icon: Icon(
                  chatBloc.state.modo == 1
                      ? Icons.text_fields_rounded
                      : Icons.image,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              if (state.modo == 1)
                IconButton(
                    onPressed: () => CustomWidgets.crearBuildImage(context),
                    icon: const Icon(
                      Icons.info,
                      color: Colors.white,
                    )),
              if (state.msg.isNotEmpty)
                IconButton(
                    onPressed: () {
                      chatBloc.clearData();
                    },
                    icon: const Icon(Icons.delete)),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      children: [
                        FadeInLeft(
                            duration: const Duration(milliseconds: 900),
                            child: RobotChat(
                              state: state,
                            )),
                      ],
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: state.msg.isEmpty
                        ? NoMsgPage(
                            state: state,
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: state.msg.length,
                            itemBuilder: (ctx, i) => _crearBody(state.msg[i]),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const InputChat()
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _crearBody(ChatModel msg) {
    switch (msg.tipo) {
      case 0:
        return MessageBubble(de: msg.de, para: msg.para, texto: msg.mensaje);
      case 1:
        return ImageBubble(de: msg.de, para: msg.para, texto: msg.mensaje);
      default:
        return MessageBubble(de: msg.de, para: msg.para, texto: msg.mensaje);
    }
  }
}
