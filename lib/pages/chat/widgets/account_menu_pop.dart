import 'dart:io';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class AccountMenuPop extends StatelessWidget {
  const AccountMenuPop({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    var formatter = NumberFormat('###,###,000');
    final resp = AppLocalizations.of(context)!;

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(
        size: 30,
        Icons.account_circle,
        color: Colors.white,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final action =
              await Dialogs.yesAbortDialog(context, resp.logout1, resp.logout2);
          if (action == DialogAction.yes) {
            loginBloc.logout();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'login');
          } else {}
        }
        if (selectedValue == 1) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, 'premium');
        }
        if (selectedValue == 2) {
          final action =
              // ignore: use_build_context_synchronously
              await Dialogs.yesAbortDialog(context, "Delete Account",
                  "Are you sure to delete your account?");
          if (action == DialogAction.yes) {
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, 'deleteAccount');
          } else {}
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                LottieBuilder.asset(
                  'assets/images/premium.json',
                  height: 25,
                ),
                Text(
                  formatter.format(loginBloc.usuario!.tokens),
                  style: const TextStyle(fontSize: 15),
                ),
                const Text(
                  "  Tokens",
                  style: TextStyle(fontSize: 13),
                )
              ],
            )),
        PopupMenuItem(
            value: 0,
            child: Row(
              children: const [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                  size: 15,
                ),
                Text(
                  "  Logout",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            )),
        if (Platform.isIOS)
          PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red[700],
                    size: 15,
                  ),
                  Text(
                    "  Delete Account",
                    style: TextStyle(fontSize: 15, color: Colors.red[700]),
                  ),
                ],
              )),
      ],
    );
  }
}
