import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

class PremiumListBody extends StatefulWidget {
  const PremiumListBody({super.key});

  @override
  State<PremiumListBody> createState() => _PremiumListBodyState();
}

class _PremiumListBodyState extends State<PremiumListBody> {
  var controller = MaskedTextController(mask: '000.000.000');
  double tokens = 5000;
  var formatter = NumberFormat('#,##,000');
  late PagosBloc pagosBloc;

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black54,
          ),
          child: BlocBuilder<PagosBloc, PagosState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  _header(),
                  _logicaInput(),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 180,
                    child: Row(
                      children: [
                        const Text(
                          "Obtendras:",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          formatter.format(state.tokensAComprar),
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Image.asset(
          'images/logo.png',
          height: 80,
        ),
        const SizedBox(
          width: 25,
        ),
        SizedBox(
          width: 150,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Tokens',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '5.000 Tokens = 1\$',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logicaInput() {
    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration:
              inputCustomDecoration('Cantidad', Icons.attach_money_outlined),
          keyboardType: TextInputType.number,
          controller: controller,
          onChanged: (value) {
            if (controller.text.isNotEmpty) {
              final value = double.parse(controller.value.text);

              final totalTokes = value.round() * tokens;
              pagosBloc.add(SetCompra(totalTokes, value));
            } else {
              pagosBloc.add(SetCompra(0, 0));
            }
          },
        ),
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
