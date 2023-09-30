part of 'conversaciones_bloc.dart';

class ConversacionesState {
  final List<ChatResponse> conversaciones;
  final String uidConv;

  ConversacionesState({
    this.conversaciones = const [],
    this.uidConv = '0',
  });

  ConversacionesState copyWith({
    List<ChatResponse>? conversaciones,
    String? uidConv,
  }) =>
      ConversacionesState(
        conversaciones: conversaciones ?? this.conversaciones,
        uidConv: uidConv ?? this.uidConv,
      );
}
