import 'package:bubble/bubble.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RobotChat extends StatelessWidget {
  final ChatState state;
  const RobotChat({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (state.msg.isNotEmpty) ...[
          LottieBuilder.asset(
            'images/robot0.json',
            height: 50,
          ),
          SizedBox(
            height: 30,
            child: Bubble(
                nip: BubbleNip.leftTop,
                child: state.escribiendo == false
                    ? const Text(
                        "Hello...",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )
                    : Row(
                        children: [
                          Text(
                            state.modo == 0
                                ? "Escribiendo"
                                : "Generando Imagen",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          JumpingDotsProgressIndicator(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      )),
          ),
        ],
      ],
    );
  }
}
