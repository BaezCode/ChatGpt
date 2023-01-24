import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPopChat extends StatelessWidget {
  const MenuPopChat({super.key});

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final prefs = PreferenciasUsuario();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return PopupMenuButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Colors.white,
            size: 20,
          ),
          onSelected: (int selectedValue) async {
            if (selectedValue == 0) {
              if (state.modo == 0) {
                chatBloc.clearData();
                chatBloc.add(SetModo(1));
                if (prefs.vistoImagen == false) {
                  CustomWidgets.crearBuildImage(context);
                }
              } else {
                chatBloc.clearData();
                chatBloc.add(SetModo(0));
                if (prefs.vistoImagen == false) {
                  CustomWidgets.crearBuildImage(context);
                }
              }
            }
            if (selectedValue == 1) {
              if (state.modo == 0) {
                CustomWidgets.crearBuildText(context);
              } else {
                CustomWidgets.crearBuildImage(context);
              }
            }
            if (selectedValue == 2) {
              CustomWidgets.buildSliderRange(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text(
                state.modo == 1 ? 'Modo Consulta' : 'Generador de Imagen',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const PopupMenuItem(
              value: 1,
              child: Text(
                'Informaciones',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text(
                'Configurar Tokens',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}
