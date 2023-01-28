part of 'pagos_bloc.dart';

@immutable
abstract class PagosEvent {}

class SetCompra extends PagosEvent {
  final int tokensAComprar;
  final String idCompra;

  SetCompra(this.tokensAComprar, this.idCompra);
}
