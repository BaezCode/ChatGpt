import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotonGooglePay extends StatefulWidget {
  const BotonGooglePay({
    super.key,
  });

  @override
  State<BotonGooglePay> createState() => _BotonGooglePayState();
}

class _BotonGooglePayState extends State<BotonGooglePay> {
  late PagosBloc pagosBloc;

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
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
                onPressed: () async {}),
          ),
        );
      },
    );
  }
}
