import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/models/usuario_model.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<ChatModel> chats = [];
  final prefs = PreferenciasUsuario();
  ChatBloc() : super(ChatState()) {
    on<SetListChats>((event, emit) {
      emit(state.copyWith(msg: event.msg));
    });
    on<SetEscribiendo>((event, emit) {
      emit(state.copyWith(escribiendo: event.escribiendo));
    });
    on<SetModo>((event, emit) {
      emit(state.copyWith(modo: event.modo));
    });
    on<SetTokens>((event, emit) {
      emit(state.copyWith(tokens: event.tokens));
    });
  }

  void clearData() {
    chats.clear();
    add(SetListChats(chats));
  }

  void addChats(ChatModel chatModel) {
    chats.insert(0, chatModel);
    add(SetListChats(chats));
  }

  Future<bool> getMesaje(String texto, Usuario usuario) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes",
    );
    final data = {
      "model": "text-davinci-003",
      "prompt": texto,
      "max_tokens": 100,
      "temperature": 0,
      "top_p": 1,
    };

    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);
        final chatModel = ChatModel(
            de: usuario.idAssist,
            para: usuario.uid,
            tokens: respuesta['tokens'],
            mensaje: respuesta['resp'].trim(),
            dateTime: DateTime.now().millisecondsSinceEpoch,
            tipo: 0);
        chats.insert(0, chatModel);
        add(SetListChats(chats));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getImage(String texto, Usuario usuario) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/image",
    );
    final data = {"prompt": texto, "n": 1, "size": "512x512"};

    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);
        final chatModel = ChatModel(
            de: usuario.idAssist,
            para: usuario.uid,
            tokens: 200,
            mensaje: respuesta['resp'].trim(),
            dateTime: DateTime.now().millisecondsSinceEpoch,
            tipo: 1);
        chats.insert(0, chatModel);
        add(SetListChats(chats));
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
