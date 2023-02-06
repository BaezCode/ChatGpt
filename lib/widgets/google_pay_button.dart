import 'dart:io';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => _sumit(state.idCompra, state.tokensAComprar)),
          ),
        );
      },
    );
  }

  void _sumit(String id, int tokens) async {
    if (id.isNotEmpty) {
      try {
        CustomWidgets.buildLoading(context);
        data!.all.forEach((key, value) {
          package = value.getPackage(id);
        });
        await Purchases.purchasePackage(package!);
        final resp = await loginBloc.getReward(tokens);
        if (resp && mounted) {
          Navigator.pushReplacementNamed(context, 'thanks');
        }
      } catch (e) {
        print(e);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error en la Compra");
        return;
      }
    } else {
      Fluttertoast.showToast(msg: "Seleccione un Producto");
    }
  }
}
