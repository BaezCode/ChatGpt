part of 'pagos_bloc.dart';

class PagosState {
  final double tokensAComprar;
  final String valor;

  PagosState({this.tokensAComprar = 0, this.valor = ''});

  PagosState copyWith({double? tokensAComprar, String? valor}) => PagosState(
      tokensAComprar: tokensAComprar ?? this.tokensAComprar,
      valor: valor ?? this.valor);
}
