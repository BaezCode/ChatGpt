import 'package:chat_gpt/bloc/bloc/pagos_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final pagosBloc = BlocProvider.of<PagosBloc>(context);

    return Drawer(
      backgroundColor: Color(0xff21232A),
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () async {
              final action = await Dialogs.yesAbortDialog(
                  context, 'Cerrar', 'Desea salir?');
              if (action == DialogAction.yes) {
                loginBloc.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'loading');
              } else {}
            },
            leading: const Icon(
              Icons.exit_to_app,
              size: 25,
              color: Colors.white,
            ),
            title: const Text(
              "Salir",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text("Google Pay"),
            onTap: () async {
              /*
              final resp = await pagosBloc.pagarApplePayGooglePay('15', 'USD');

              print(resp);
              */
            },
          )
        ],
      )),
    );
  }
}
