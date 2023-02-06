part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class SetListChats extends ChatEvent {
  final List<ChatModel> msg;

  SetListChats(this.msg);
}

class SetEscribiendo extends ChatEvent {
  final bool escribiendo;

  SetEscribiendo(this.escribiendo);
}

class SetModo extends ChatEvent {
  final int modo;

  SetModo(this.modo);
}

class SetTokens extends ChatEvent {
  final int tokens;

  SetTokens(this.tokens);
}

class SetConectado extends ChatEvent {
  final bool conectado;

  SetConectado(this.conectado);
}
