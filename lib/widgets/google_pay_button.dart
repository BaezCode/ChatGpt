import 'dart:async';

import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BotonGooglePay extends StatefulWidget {
  const BotonGooglePay({
    super.key,
  });

  @override
  State<BotonGooglePay> createState() => _BotonGooglePayState();
}

class _BotonGooglePayState extends State<BotonGooglePay> {
  late PagosBloc pagosBloc;
  final appPurchae = InAppPurchase.instance;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchase = [];
  List<String> kProductIds = <String>['tokens_10'];
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);

    initStoreInfo();
    final purchaseUpdated = appPurchae.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (event) {
        print(event);
      },
      onDone: () {},
      onError: (error) {
        print(error);
      },
    );
  }

  void initStoreInfo() async {
    final appPurchae = InAppPurchase.instance;
    final resp = await appPurchae.isAvailable();
    if (resp) {
      final ProductDetailsResponse productDetailResponse =
          await appPurchae.queryProductDetails(kProductIds.toSet());
      products.addAll(productDetailResponse.productDetails);
    }
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
                onPressed: () async {
                  final purchaseParam =
                      PurchaseParam(productDetails: products[0]);
                  await appPurchae.buyConsumable(
                      purchaseParam: purchaseParam, autoConsume: true);
                }),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
