import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/models/token_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PremiumListBody extends StatefulWidget {
  const PremiumListBody({super.key});

  @override
  State<PremiumListBody> createState() => _PremiumListBodyState();
}

class _PremiumListBodyState extends State<PremiumListBody> {
  var formatter = NumberFormat('###,###,000');
  late PagosBloc pagosBloc;
  final List<TokenModel> lista = [
    TokenModel(
        titulo: '25.000 Tokens',
        tokens: 25000,
        value: '3.99',
        keyData: 'tokens_ap_5'),
    TokenModel(
        titulo: '50.000 Tokens',
        tokens: 50000,
        value: '6.99',
        keyData: 'tokens_ap_10'),
    TokenModel(
        titulo: '100.000 Tokens',
        tokens: 1000000,
        value: '11.99',
        keyData: 'tokens_ap_15')
  ];

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: lista.length,
              itemBuilder: (ctx, i) => _header(lista[i], state.idCompra)),
        );
      },
    );
  }

  Widget _header(TokenModel tokenModel, String keydata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: GestureDetector(
        onTap: () =>
            pagosBloc.add(SetCompra(tokenModel.tokens, tokenModel.keyData)),
        child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black38,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  keydata == tokenModel.keyData
                      ? Icons.circle_rounded
                      : Icons.circle_outlined,
                  color: Colors.blue[700],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  tokenModel.titulo,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${tokenModel.value} \$",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            )),
      ),
    );
  }

  InputDecoration inputCustomDecoration(String label, IconData icon) {
    return InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label,
        suffixIcon: Icon(
          icon,
          color: Colors.white,
        ));
  }
}
