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
    final size = MediaQuery.of(context).size;
    var formatter = NumberFormat('###,###,000');
    final resp = AppLocalizations.of(context)!;
    final List<String> datos = [
      resp.pr1,
      resp.pr2,
      resp.pr3,
      resp.pr4,
      resp.pr5,
    ];
    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: loginBloc.state.susActive
              ? null
              : Platform.isAndroid
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
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: size.width * 0.55,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: datos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green[700],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              datos[index],
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (loginBloc.state.susActive == false) const PremiumListBody(),
                if (loginBloc.state.susActive) ...[
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 75),
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minWidth: 1,
                          color: Colors.black,
                          onPressed: () {},
                          child: const Text(
                            'Your subscription is active',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
