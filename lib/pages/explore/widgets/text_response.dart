import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/bloc/action/action_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/pages/explore/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextResponse extends StatefulWidget {
  const TextResponse({super.key});

  @override
  State<TextResponse> createState() => _TextResponseState();
}

class _TextResponseState extends State<TextResponse> {
  late ActionBloc actionBloc;
  late LoginBloc loginBloc;
  bool keyData = true;

  @override
  void initState() {
    super.initState();
    actionBloc = BlocProvider.of<ActionBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);

    actionBloc.response = actionBloc.state.opcionesLista!.initalResponse;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ActionBloc, ActionState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              texto: "Generate Response",
              state: state,
              onPressed: state.estaEscribiendo ? null : _submit,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsetsDirectional.all(15),
                width: size.width,
                height: size.height * 0.30,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: SingleChildScrollView(
                  child: AnimatedTextKit(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      key: ValueKey<bool>(keyData),
                      isRepeatingAnimation: false,
                      displayFullTextOnTap: true,
                      animatedTexts: [
                        TypewriterAnimatedText(actionBloc.response,
                            textStyle: const TextStyle(color: Colors.white))
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: actionBloc.response));
                            Fluttertoast.showToast(msg: "Copied To Clipboard");
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () async {
                            await FlutterShare.share(
                              title: 'Share',
                              text: actionBloc.response,
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.share,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  void _submit() async {
    if (!actionBloc.formKey.currentState!.validate()) return;
    actionBloc.formKey.currentState!.save();
    if (loginBloc.usuario!.tokens! <= 35 &&
        loginBloc.state.susActive == false) {
      Fluttertoast.showToast(msg: 'Low Tokens');
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      await actionBloc.getMesaje(
          actionBloc.textController.text.trim(), loginBloc);
      setState(() {
        keyData = !keyData;
      });
    }
  }
}
