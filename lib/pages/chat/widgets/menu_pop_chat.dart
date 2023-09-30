import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class MenuPopChat extends StatelessWidget {
  const MenuPopChat({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return PopupMenuButton(
          color: const Color(0xfff20262e),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 20,
          ),
          onSelected: (int selectedValue) async {
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
              value: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(CupertinoIcons.info),
                  Text(
                    resp.info,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(CupertinoIcons.wrench),
                  Text(
                    resp.tokensConfig,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
