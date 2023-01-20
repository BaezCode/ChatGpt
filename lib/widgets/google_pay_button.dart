import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class BotonGooglePay extends StatelessWidget {
  const BotonGooglePay({super.key});

  @override
  Widget build(BuildContext context) {
    const paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '99.99',
        status: PaymentItemStatus.final_price,
      )
    ];
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: GooglePayButton(
            paymentConfigurationAsset: 'google_pay.json',
            onPaymentResult: (result) {
              print(result);
            },
            paymentItems: paymentItems));
  }
}
