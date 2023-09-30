part of 'chat_bloc.dart';

class ChatState {
  final List<ChatModel> msg;
  final bool escribiendo;
  final int modo;
  final int tokens;
  final bool conectado;
  final bool estaEscribiendo;
  final int indexHome;

  ChatState({
    this.msg = const [],
    this.escribiendo = false,
    this.modo = 0,
    this.tokens = 0,
    this.conectado = false,
    this.estaEscribiendo = false,
    this.indexHome = 0,
  });

  ChatState copyWith({
    List<ChatModel>? msg,
    bool? escribiendo,
    int? modo,
    int? tokens,
    bool? conectado,
    bool? estaEscribiendo,
    int? indexHome,
  }) =>
      ChatState(
        msg: msg ?? this.msg,
        escribiendo: escribiendo ?? this.escribiendo,
        modo: modo ?? this.modo,
        tokens: tokens ?? this.tokens,
        conectado: conectado ?? this.conectado,
        estaEscribiendo: estaEscribiendo ?? this.estaEscribiendo,
        indexHome: indexHome ?? this.indexHome,
      );
}
