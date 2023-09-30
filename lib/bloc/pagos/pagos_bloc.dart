import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
part 'pagos_event.dart';
part 'pagos_state.dart';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  PagosBloc() : super(PagosState()) {
    on<SetCompra>((event, emit) {
      emit(state.copyWith(idCompra: event.idCompra, package: event.package));
    });
  }
}
