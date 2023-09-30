part of 'pagos_bloc.dart';

@immutable
abstract class PagosEvent {}

class SetCompra extends PagosEvent {
  final String idCompra;
  final Package? package;

  SetCompra(this.idCompra, this.package);
}
