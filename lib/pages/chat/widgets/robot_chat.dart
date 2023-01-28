import 'package:bubble/bubble.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class RobotChat extends StatelessWidget {
  final ChatState state;
  const RobotChat({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LottieBuilder.asset(
          'assets/images/robot0.json',
          height: 50,
        ),
        SizedBox(
          height: 30,
          child: Bubble(
              nip: BubbleNip.leftTop,
              child: state.escribiendo == false
                  ? const Text(
                      "Hello...",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  : Row(
                      children: [
                        Text(
                          resp.tipping,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
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
    );
  }
}
