import 'package:chat_gpt/bloc/action/action_bloc.dart';
import 'package:chat_gpt/helper/navegar_fadein.dart';
import 'package:chat_gpt/models/lista_datos.dart';
import 'package:chat_gpt/pages/explore/widgets/action_page.dart';
import 'package:chat_gpt/pages/explore/widgets/customLista.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = CustomLista.listReturn(context);
    final resp = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                resp.explore,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: _BuildCards(data: list[index]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildCards extends StatelessWidget {
  final OpcionesLista data;
  const _BuildCards({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final actionBloc = BlocProvider.of<ActionBloc>(context);

    return GestureDetector(
      onTap: () {
        actionBloc.add(SetOpcionesLista(data));
        Navigator.push(context, navegarFadeIn(context, ActionPage(data: data)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[900], borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                data.asset,
                height: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                data.titulo,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data.descripcion,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
