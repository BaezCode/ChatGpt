import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class TextVariation extends StatelessWidget {
  final String texto;
  const TextVariation({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
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
              texto,
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
    );
  }
}
