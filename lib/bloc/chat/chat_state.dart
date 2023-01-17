part of 'chat_bloc.dart';

class ChatState {
  final List<ChatModel> msg;
  final bool escribiendo;
  final int modo;

  ChatState({this.msg = const [], this.escribiendo = false, this.modo = 0});

  ChatState copyWith({List<ChatModel>? msg, bool? escribiendo, int? modo}) =>
      ChatState(
          msg: msg ?? this.msg,
          escribiendo: escribiendo ?? this.escribiendo,
          modo: modo ?? this.modo);
}
