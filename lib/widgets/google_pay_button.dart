import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class BotonGooglePay extends StatefulWidget {
  const BotonGooglePay({
    super.key,
  });

  @override
  State<BotonGooglePay> createState() => _BotonGooglePayState();
}

class _BotonGooglePayState extends State<BotonGooglePay> {
  late LoginBloc loginBloc;

  Offerings? data;
  Package? package;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    purchastest();
  }

  void purchastest() async {
    data = await Purchases.getOfferings();
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: 1,
                color: Colors.red[900],
                child: Text(
                  resp.confirm,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => _sumit(
                    state.idCompra, state.tokensAComprar, state.package)),
          ),
        );
      },
    );
  }

  void _sumit(String id, int tokens, Package? package) async {
    if (id.isNotEmpty) {
      try {
        CustomWidgets.buildLoading(context);
        final resp = await Purchases.purchasePackage(package!);
        if (resp.activeSubscriptions.isNotEmpty && mounted) {
          loginBloc.add(SetSuscriptionActive(true));
          Navigator.pushReplacementNamed(context, 'thanks');
        }
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error Try Again");
        return;
      }
    } else {
      Fluttertoast.showToast(msg: "Select a Product");
    }
  }
}
