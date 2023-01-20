part of 'pagos_bloc.dart';

class PagosState {
  final double tokensAComprar;
  final double valor;

  PagosState({this.tokensAComprar = 0, this.valor = 0});

  PagosState copyWith({double? tokensAComprar, double? valor}) => PagosState(
      tokensAComprar: tokensAComprar ?? this.tokensAComprar,
      valor: valor ?? this.valor);
}
