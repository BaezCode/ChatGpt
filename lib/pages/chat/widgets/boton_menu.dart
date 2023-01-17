import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BotonMenu extends StatelessWidget {
  const BotonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      buttonSize: Size(45, 45),
      backgroundColor: const Color(0xff424549),
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      children: [SpeedDialChild(label: "Menu")],
    );
  }
}
