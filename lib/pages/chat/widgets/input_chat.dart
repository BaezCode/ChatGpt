import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/pages/chat/widgets/menu_pop_chat.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class InputChat extends StatefulWidget {
  const InputChat({super.key});

  @override
  State<InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<InputChat> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatBloc chatBloc;
  late LoginBloc loginBloc;
  late PagosBloc pagosBloc;
  final prefs = PreferenciasUsuario();

  bool respondiendo = false;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    pagosBloc = BlocProvider.of<PagosBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xff21232A),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    pagosBloc.add(SetCompra(5000, '1'));
                    Navigator.pushNamed(context, 'premium');
                  },
                  child: Container(
                      width: 40,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.purpleAccent,
                            Colors.indigoAccent,
                          ],
                        ),
                      ),
                      child: LottieBuilder.asset(
                        'assets/images/premium.json',
                        height: 100,
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff424549),
                      borderRadius: BorderRadius.circular(10)),
                  width: size.width * 0.60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(60),
                      ],
                      autofocus: false,
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(
                          fillColor: Colors.white,
                          hintText: 'Enviar Mensaje',
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 20,
                  child: IconButton(
                      onPressed: state.escribiendo
                          ? null
                          : () => state.modo == 0
                              ? submitText(_textController.text.trim())
                              : submitImage(_textController.text.trim()),
                      icon: const Icon(
                        CupertinoIcons.location_fill,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            );
          },
        ),
      )),
    );
  }

  void submitImage(String texto) async {
    if (texto.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    if (loginBloc.usuario!.tokens! <= 35) {
      Fluttertoast.showToast(msg: 'Tokens Agotados o por debajo del Limite');
    } else {
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
  }

  void submitText(String texto) async {
    if (texto.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    if (loginBloc.usuario!.tokens! <= 35) {
      Fluttertoast.showToast(msg: 'Tokens Agotados o por debajo del Limite');
    } else {
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
}
