import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';
import 'package:progress_indicators/progress_indicators.dart';

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
  bool textoEscrito = false;

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
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.escribiendo)
              Container(
                color: const Color(0xff21232A),
                width: double.infinity,
                height: 40,
                child: FadeInLeft(
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                      ),
                      Text(
                        resp.tipping,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      JumpingDotsProgressIndicator(
                        numberOfDots: 4,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            Container(
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
                            pagosBloc.add(SetCompra(0, ''));
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
                          width: size.width * 0.65,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextField(
                              autofocus: false,
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
                        CircleAvatar(
                          radius: 22,
                          child: IconButton(
                              onPressed: state.escribiendo
                                  ? null
                                  : textoEscrito == false
                                      ? _submitImage
                                      : () => state.modo == 0
                                          ? submitText(
                                              _textController.text.trim())
                                          : submitImage(
                                              _textController.text.trim()),
                              icon: state.modo == 1 && textoEscrito == false
                                  ? const Icon(Icons.image)
                                  : const Icon(
                                      CupertinoIcons.location_fill,
                                      color: Colors.white,
                                      size: 25,
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
            ),
          ],
        );
      },
    );
  }

  void _submitImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) {
      return;
    }
    final resp = await chatBloc.getImagesVariation(pickedFile.path);
    print(resp);
  }

  void submitImage(String texto) async {
    if (texto.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    if (loginBloc.usuario!.tokens! <= 35) {
      Fluttertoast.showToast(msg: 'Tokens Agotados o por debajo del Limite');
      setState(() {
        textoEscrito = false;
      });
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
      setState(() {
        textoEscrito = false;
      });
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
