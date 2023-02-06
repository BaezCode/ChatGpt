part of 'chat_bloc.dart';

class ChatState {
  final List<ChatModel> msg;
  final bool escribiendo;
  final int modo;
  final int tokens;
  final bool conectado;

  ChatState({
    this.msg = const [],
    this.escribiendo = false,
    this.modo = 0,
    this.tokens = 0,
    this.conectado = false,
  });

  ChatState copyWith({
    List<ChatModel>? msg,
    bool? escribiendo,
    int? modo,
    int? tokens,
    bool? conectado,
  }) =>
      ChatState(
        msg: msg ?? this.msg,
        escribiendo: escribiendo ?? this.escribiendo,
        modo: modo ?? this.modo,
        tokens: tokens ?? this.tokens,
        conectado: conectado ?? this.conectado,
      );
}
