part of 'pagos_bloc.dart';

class PagosState {
  final int tokensAComprar;
  final String valor;
  final String idCompra;

  PagosState({this.tokensAComprar = 0, this.valor = '', this.idCompra = ''});

  PagosState copyWith({int? tokensAComprar, String? valor, String? idCompra}) =>
      PagosState(
          tokensAComprar: tokensAComprar ?? this.tokensAComprar,
          valor: valor ?? this.valor,
          idCompra: idCompra ?? this.idCompra);
}
