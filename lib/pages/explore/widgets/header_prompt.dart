import 'package:chat_gpt/bloc/action/action_bloc.dart';
import 'package:chat_gpt/helper/customDecoration.dart';
import 'package:chat_gpt/models/lista_datos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HeaderPromt extends StatefulWidget {
  final OpcionesLista data;
  const HeaderPromt({super.key, required this.data});

  @override
  State<HeaderPromt> createState() => _HeaderPromtState();
}

class _HeaderPromtState extends State<HeaderPromt> {
  late ActionBloc actionBloc;

  @override
  void initState() {
    super.initState();
    actionBloc = BlocProvider.of<ActionBloc>(context);
    actionBloc.textController.text = widget.data.initialPrompt;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionBloc, ActionState>(
      builder: (context, state) {
        return Form(
          key: actionBloc.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      " Prompt",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          actionBloc.textController.clear();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.grey[400],
                        )),
                    IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: actionBloc.response));
                          Fluttertoast.showToast(msg: "Copied To Clipboard");
                        },
                        icon: Icon(
                          Icons.copy,
                          color: Colors.grey[400],
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    key: const ValueKey('Prompt'),
                    controller: actionBloc.textController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Prompt ist Empty';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    maxLines: 8,
                    decoration: CustomDecoration.buildInputDecoration(
                        'Write', '', Icons.account_circle),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
