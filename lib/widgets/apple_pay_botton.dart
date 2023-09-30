import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class ApplePayButton extends StatefulWidget {
  const ApplePayButton({super.key});

  @override
  State<ApplePayButton> createState() => _ApplePayButtonState();
}

class _ApplePayButtonState extends State<ApplePayButton> {
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
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
                color: Colors.black,
                onPressed: () => _sumit(state.idCompra, state.tokensAComprar),
                child: Text(
                  resp.confirm,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )),
          ),
        );
      },
    );
  }

  void _sumit(String id, int tokens) async {
    if (id.isNotEmpty) {
      try {
        CustomWidgets.buildLoading(context);
        await Purchases.purchaseProduct(id);
        Navigator.pushReplacementNamed(context, 'thanks');
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error en la Compra");
        return;
      }
    } else {
      Fluttertoast.showToast(msg: "Seleccione un Producto");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
