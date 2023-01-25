import 'package:flutter/material.dart';

class BotonLogin extends StatelessWidget {
  final String texto;
  final IconData icon;
  final Color? color;
  final Color iconColor;
  final Color textColor;
  final Function()? onPressed;
  const BotonLogin(
      {super.key,
      required this.texto,
      required this.icon,
      required this.color,
      required this.iconColor,
      required this.textColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color,
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            Text(
              texto,
              style: TextStyle(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
