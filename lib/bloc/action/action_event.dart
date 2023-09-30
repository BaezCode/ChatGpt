part of 'action_bloc.dart';

abstract class ActionEvent {}

class SetOpcionesLista extends ActionEvent {
  final OpcionesLista opcionesLista;

  SetOpcionesLista(this.opcionesLista);
}

class SetEstaEscribiendo extends ActionEvent {
  final bool estaEscribiendo;

  SetEstaEscribiendo(this.estaEscribiendo);
}
