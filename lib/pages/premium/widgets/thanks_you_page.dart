import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class ThanksYouPage extends StatelessWidget {
  const ThanksYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,000');
    final resp = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xff21232A),
      body: BlocBuilder<PagosBloc, PagosState>(
        builder: (context, state) {
          return Column(
            children: [
              LottieBuilder.asset(
                  repeat: false, 'assets/images/confirmado.json'),
              Text(
                resp.pay1,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${formatter.format(state.tokensAComprar)}, ${resp.pay2}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 25,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.black,
                  child: Text(
                    resp.confirm,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'chat'))
            ],
          );
        },
      ),
    );
  }
}
