import 'dart:io';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/pages/premium/widgets/premium_list_body.dart';
import 'package:chat_gpt/widgets/apple_pay_botton.dart';
import 'package:chat_gpt/widgets/google_pay_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    var formatter = NumberFormat('###,###,000');
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: Platform.isAndroid
              ? const BotonGooglePay()
              : const ApplePayButton(),
          backgroundColor: const Color(0xff21232A),
          appBar: AppBar(
            title: Text(
              "${resp.premium1} ${formatter.format(loginBloc.usuario!.tokens)} Tokens",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel)),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LottieBuilder.asset(
                  'assets/images/premium.json',
                  height: 100,
                ),
                Text(
                  resp.premium2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  resp.premium3,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                const PremiumListBody(),
              ],
            ),
          ),
        );
      },
    );
  }
}
