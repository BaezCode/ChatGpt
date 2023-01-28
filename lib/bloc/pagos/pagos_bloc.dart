import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
part 'pagos_event.dart';
part 'pagos_state.dart';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  PagosBloc() : super(PagosState()) {
    on<SetCompra>((event, emit) {
      emit(state.copyWith(
          tokensAComprar: event.tokensAComprar, idCompra: event.idCompra));
    });
  }
}
