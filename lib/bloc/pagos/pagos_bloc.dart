import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'pagos_event.dart';
part 'pagos_state.dart';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  PagosBloc() : super(PagosState()) {
    on<SetCompra>((event, emit) {
      emit(state.copyWith(
          tokensAComprar: event.tokensAComprar, valor: event.valor));
    });
  }

  /*

  Future pagarApplePayGooglePay(String amount, String currency) async {
    try {
      final newAmount = double.parse(amount) / 100;

      final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions:
              AndroidPayPaymentRequest(currencyCode: 'USD', totalPrice: amount),
          applePayOptions: ApplePayPaymentOptions(
              countryCode: 'US',
              currencyCode: 'USD',
              items: [
                ApplePayItem(label: 'Super producto 1', amount: '$newAmount')
              ]));

      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: CreditCard(token: token.tokenId)));

      final resp = await intentoDePago(amount, currency, paymentMethod);
      await StripePayment.completeNativePayRequest();
      return resp;
    } catch (e) {
      return e;
    }
  }

  //Crear Intento de Pago
  Future intentoDePago(
      String amount, String currency, PaymentMethod paymentMethod) async {
    final data = {
      'amount': amount,
      'currency': currency,
      'metod': paymentMethod.id
    };
    final token = await storage.read(key: 'token') ?? '';

    final uri = Uri.parse(
      "${Environment.apiUrl}/pay",
    );
    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        final respose = jsonDecode(resp.body);
        print(respose);

        return true;
      } else {
        final respBody = jsonDecode(resp.body);
        return respBody['msg'];
      }
    } catch (e) {
      return e;
    }
  }
  */
}
