import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AccountMenuPop extends StatelessWidget {
  const AccountMenuPop({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    var formatter = NumberFormat('###,###,000');

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(
        size: 30,
        Icons.account_circle,
        color: Colors.white,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final action = await Dialogs.yesAbortDialog(context, 'Cerrar sesión',
              '¿Estás seguro de que quieres Cerrar sesión?');
          if (action == DialogAction.yes) {
            loginBloc.logout();
            Navigator.pushReplacementNamed(context, 'login');
          } else {}
        }
        if (selectedValue == 1) {
          Navigator.pushNamed(context, 'premium');
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
                  "  Desloguear",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            )),
      ],
    );
  }
}
