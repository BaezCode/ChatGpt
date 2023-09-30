import 'package:chat_gpt/models/lista_datos.dart';
import 'package:chat_gpt/pages/explore/widgets/header_prompt.dart';
import 'package:chat_gpt/pages/explore/widgets/image_response.dart';
import 'package:chat_gpt/pages/explore/widgets/text_response.dart';
import 'package:flutter/material.dart';

class ActionPage extends StatelessWidget {
  final OpcionesLista data;
  const ActionPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xfff20262e),
          title: Text(data.titulo),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                HeaderPromt(
                  data: data,
                ),
                _Body(
                  data: data,
                )
              ],
            ),
          ),
        ));
  }
}

class _Body extends StatelessWidget {
  final OpcionesLista data;
  const _Body({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    switch (data.type) {
      case 0:
        return TextResponse();
      case 1:
        return ImageResponse();
      default:
        return TextResponse();
    }
  }
}
