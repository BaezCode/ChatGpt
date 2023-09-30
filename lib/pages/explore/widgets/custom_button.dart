import 'package:chat_gpt/bloc/action/action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class CustomButton extends StatelessWidget {
  final String texto;
  final ActionState state;
  final Function()? onPressed;
  const CustomButton(
      {super.key, required this.texto, required this.state, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        height: 50,
        minWidth: size.width - 90,
        color: Colors.blue[700],
        onPressed: onPressed,
        child: state.estaEscribiendo
            ? _loading(size)
            : Text(
                texto,
                style: TextStyle(color: Colors.white),
              ));
  }

  Widget _loading(Size size) {
    return SizedBox(
      width: size.width - 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            texto,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(
            width: 5,
          ),
          JumpingDotsProgressIndicator(
            numberOfDots: 4,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
