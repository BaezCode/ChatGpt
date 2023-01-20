part of 'pagos_bloc.dart';

@immutable
abstract class PagosEvent {}

class SetCompra extends PagosEvent {
  final double tokensAComprar;
  final double valor;

  SetCompra(this.tokensAComprar, this.valor);
}
