import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'pagos_event.dart';
part 'pagos_state.dart';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  static InAppPurchase? _instance;

  FlutterSecureStorage storage = const FlutterSecureStorage();
  PagosBloc() : super(PagosState()) {
    on<SetCompra>((event, emit) {
      emit(state.copyWith(
          tokensAComprar: event.tokensAComprar, valor: event.valor));
    });
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}
