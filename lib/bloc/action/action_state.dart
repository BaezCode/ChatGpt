part of 'action_bloc.dart';

class ActionState {
  final OpcionesLista? opcionesLista;
  final bool estaEscribiendo;

  ActionState({
    this.opcionesLista,
    this.estaEscribiendo = false,
  });

  ActionState copyWith({
    OpcionesLista? opcionesLista,
    bool? estaEscribiendo,
  }) =>
      ActionState(
          opcionesLista: opcionesLista ?? this.opcionesLista,
          estaEscribiendo: estaEscribiendo ?? this.estaEscribiendo);
}
