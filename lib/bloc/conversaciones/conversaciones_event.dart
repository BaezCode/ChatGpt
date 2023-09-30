part of 'conversaciones_bloc.dart';

@immutable
abstract class ConversacionesEvent {}

class SetListConv extends ConversacionesEvent {
  final List<ChatResponse> conversaciones;

  SetListConv(
    this.conversaciones,
  );
}

class SetuidConv extends ConversacionesEvent {
  final String uidConv;

  SetuidConv(this.uidConv);
}
