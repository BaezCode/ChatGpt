import 'dart:convert';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/models/msg_response.dart';
import 'package:chat_gpt/models/response_model.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<ChatModel> chats = [];
  List<Message> listResp = [];

  final prefs = PreferenciasUsuario();
  FlutterSecureStorage storage = const FlutterSecureStorage();

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
    on<SetConectado>((event, emit) {
      emit(state.copyWith(conectado: event.conectado));
    });
    on<SetSiEscribo>((event, emit) {
      emit(state.copyWith(estaEscribiendo: event.estaEscribiendo));
    });
    on<SelectIndex>((event, emit) {
      emit(state.copyWith(indexHome: event.indexHome));
    });
  }

  Future selectedIndex(int index) async {
    add(SelectIndex(index));
  }

  void clearData() {
    chats.clear();
    add(SetListChats(chats));
  }

  void addChats(ChatModel chatModel) {
    chats.insert(0, chatModel);
    add(SetListChats(chats));
  }

  void chargeList(List<ChatModel> lista) {
    chats = lista;
    add(SetListChats(chats));
  }

  Future<List<ChatModel>> getGP4(
    String texto,
    LoginBloc loginBloc,
  ) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/gpt4",
    );
    final token = await storage.read(key: 'token') ?? '';

    int solicitud = loginBloc.usuario!.tokens! <= prefs.limiteToken.toInt()
        ? loginBloc.usuario!.tokens!
        : prefs.limiteToken.toInt();

    final resp = Message(role: 'user', content: texto);
    if (listResp.length > 2) {
      listResp.removeRange(0, 2);
    }
    listResp.add(resp);
    final data = {
      "tokens": 500,
      "temp": 0.7,
      'messages': listResp,
      "pro": loginBloc.state.susActive
    };
    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        final respuesta = responseModelFromJson(resp.body);

        listResp.add(respuesta.message);
        final chatModel = ChatModel(
            de: loginBloc.usuario!.idAssist,
            para: loginBloc.usuario!.uid,
            list: [],
            tokens: loginBloc.state.susActive ? 0 : respuesta.tokens,
            mensaje: respuesta.message.content,
            dateTime: DateTime.now().millisecondsSinceEpoch,
            tipo: 0);
        if (loginBloc.state.susActive == false) {
          loginBloc.usuario!.tokens =
              loginBloc.usuario!.tokens! - chatModel.tokens;
        }
        chats.insert(0, chatModel);
        add(SetListChats(chats));
        return chats;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");
        return chats;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");

      return chats;
    }
  }

  Future getMesaje(String text, LoginBloc loginBloc) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes",
    );
    final data = {
      "model": "text-davinci-003",
      "prompt": text,
      "max_tokens": prefs.limiteToken, //datos.maxtokens,
    };
    try {
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);
        final texto = respuesta['resp'].trim();
        final chatModel = ChatModel(
            de: loginBloc.usuario!.idAssist,
            para: loginBloc.usuario!.uid,
            list: [],
            tokens: loginBloc.state.susActive ? 0 : respuesta['tokens'],
            mensaje: texto,
            dateTime: DateTime.now().millisecondsSinceEpoch,
            tipo: 0);

        if (loginBloc.state.susActive == false) {
          loginBloc.usuario!.tokens =
              loginBloc.usuario!.tokens! - chatModel.tokens;
        }
        chats.insert(0, chatModel);
        return chats;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");

        return chats;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");

      return chats;
    }
  }
}
