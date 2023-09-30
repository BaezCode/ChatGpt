part of 'pagos_bloc.dart';

class PagosState {
  final int tokensAComprar;
  final String valor;
  final String idCompra;
  final Package? package;

  PagosState(
      {this.tokensAComprar = 0,
      this.valor = '',
      this.idCompra = '',
      this.package});

  PagosState copyWith(
          {int? tokensAComprar,
          String? valor,
          String? idCompra,
          Package? package}) =>
      PagosState(
          tokensAComprar: tokensAComprar ?? this.tokensAComprar,
          valor: valor ?? this.valor,
          idCompra: idCompra ?? this.idCompra,
          package: package ?? this.package);
}
