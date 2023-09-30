import 'dart:io';

import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumListBody extends StatefulWidget {
  const PremiumListBody({super.key});

  @override
  State<PremiumListBody> createState() => _PremiumListBodyState();
}

class _PremiumListBodyState extends State<PremiumListBody> {
  var formatter = NumberFormat('###,###,000');
  late PagosBloc pagosBloc;
  List<Package> packages = [];

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    init();
  }

  void init() async {
    try {
      final offering = await Purchases.getOfferings();
      packages = offering.current!.availablePackages;
      setState(() {});
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: packages.length,
              itemBuilder: (ctx, i) => _header(packages[i], state.idCompra)),
        );
      },
    );
  }

  Widget _header(Package package, String keydata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: GestureDetector(
        onTap: () {
          pagosBloc.add(SetCompra(package.storeProduct.identifier, package));
        },
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
                  keydata == package.storeProduct.identifier
                      ? Icons.circle_rounded
                      : Icons.circle_outlined,
                  color: Colors.blue[700],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  Platform.isAndroid
                      ? package.storeProduct.title.characters
                          .take(19)
                          .toString()
                      : package.storeProduct.title,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  package.storeProduct.priceString,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            )),
      ),
    );
  }

  InputDecoration inputCustomDecoration(String label, IconData icon) {
    return InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
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
