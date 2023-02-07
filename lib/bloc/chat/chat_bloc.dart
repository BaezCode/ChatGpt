import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<ChatModel> chats = [];
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
  }

  void clearData() {
    chats.clear();
    add(SetListChats(chats));
  }

  void addChats(ChatModel chatModel) {
    chats.insert(0, chatModel);
    add(SetListChats(chats));
  }

  Future<bool> getMesaje(
    String texto,
    LoginBloc loginBloc,
  ) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes",
    );
    final token = await storage.read(key: 'token') ?? '';
    int solicitud = loginBloc.usuario!.tokens! <= prefs.limiteToken.toInt()
        ? loginBloc.usuario!.tokens!
        : prefs.limiteToken.toInt();
    final data = {
      "model": "text-davinci-003",
      "prompt": texto,
      "max_tokens": solicitud,
      "temperature": 0,
    };
    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);

        final chatModel = ChatModel(
            de: loginBloc.usuario!.idAssist,
            para: loginBloc.usuario!.uid,
            tokens: respuesta['tokens'],
            mensaje: respuesta['resp'].trim(),
            dateTime: DateTime.now().millisecondsSinceEpoch,
            tipo: 0);
        loginBloc.usuario!.tokens =
            loginBloc.usuario!.tokens! - chatModel.tokens;
        chats.insert(0, chatModel);
        add(SetListChats(chats));
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");

      return false;
    }
  }

  Future<bool> getImage(String texto, LoginBloc loginBloc) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/image",
    );
    final data = {"prompt": texto, "n": 1, "size": "512x512"};
    final token = await storage.read(key: 'token') ?? '';

    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);

        final chatModel = ChatModel(
            de: loginBloc.usuario!.idAssist,
            para: loginBloc.usuario!.uid,
            tokens: 200,
            mensaje: respuesta['resp'].trim(),
            dateTime: DateTime.now().millisecondsSinceEpoch,
            tipo: 1);
        loginBloc.usuario!.tokens =
            loginBloc.usuario!.tokens! - chatModel.tokens;
        chats.insert(0, chatModel);
        add(SetListChats(chats));
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");
      return false;
    }
  }

  Future<bool> getImagesVariation(String path) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/variation",
    );
    final token = await storage.read(key: 'token') ?? '';

    Map<String, String> headers = {"x-token": token};

    try {
      final imageUplodaRequest = http.MultipartRequest(
        'POST',
        uri,
      );
      imageUplodaRequest.headers.addAll(headers);
      final file = await http.MultipartFile.fromPath('archivo', path);
      imageUplodaRequest.files.add(file);
      final streamResponse = await imageUplodaRequest.send();
      final resp = await http.Response.fromStream(streamResponse);
      if (resp.statusCode == 201) {
        print(resp.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
