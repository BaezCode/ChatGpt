import 'dart:io';

import 'package:chat_gpt/pages/premium/widgets/premium_list_body.dart';
import 'package:chat_gpt/widgets/google_pay_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff21232A),
      bottomNavigationBar:
          Platform.isAndroid ? const BotonGooglePay() : const BotonGooglePay(),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: Colors.red,
                size: 12,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Inactivo",
                style: TextStyle(color: Colors.red[700]),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          )
        ],
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
              'images/premium.json',
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
            const PremiumListBody(),
          ],
        ),
      ),
    );
  }
}
