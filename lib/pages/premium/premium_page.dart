import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/pages/premium/widgets/premium_list_body.dart';
import 'package:chat_gpt/widgets/google_pay_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    var formatter = NumberFormat('###,###,000');

    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: const BotonGooglePay(),
          backgroundColor: const Color(0xff21232A),
          appBar: AppBar(
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
                const Text(
                  "Comprar Tokens",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Con la Compra Ayudas a mantener la App Activa",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Tienes Disponible: ${formatter.format(loginBloc.usuario!.tokens)} Tokens",
                  style: const TextStyle(color: Colors.white),
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
