import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoMsgPage extends StatelessWidget {
  final ChatState state;
  const NoMsgPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlipInX(
          child: LottieBuilder.asset(
            'images/robot0.json',
            height: 150,
          ),
        ),
        FlipInX(
          child: Text(
              state.modo == 0
                  ? '¿En Que Puedo Ayudarte?'
                  : "Describe La Imagen que sera creada",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
