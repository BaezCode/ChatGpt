import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:chat_gpt/models/lista_datos.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

part 'action_event.dart';
part 'action_state.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  final prefs = PreferenciasUsuario();
  String response = '';
  List<dynamic> lista = [];
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  ActionBloc() : super(ActionState()) {
    on<SetOpcionesLista>((event, emit) {
      emit(state.copyWith(opcionesLista: event.opcionesLista));
    });
    on<SetEstaEscribiendo>((event, emit) {
      emit(state.copyWith(estaEscribiendo: event.estaEscribiendo));
    });
  }

  Future getMesaje(String text, LoginBloc loginBloc) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes",
    );
    final datos = state.opcionesLista!;
    final data = {
      "model": "text-davinci-003",
      "prompt": text,
      "temperature": datos.temperature,
      "max_tokens": datos.maxtokens, //datos.maxtokens,
      "top_p": datos.topP,
      "frequency_penalty": datos.frequencypenalty,
      "presence_penalty": datos.presencepenalty
    };
    try {
      add(SetEstaEscribiendo(true));
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);
        final texto = respuesta['resp'].trim();
        response = texto;

        if (loginBloc.state.susActive == false) {
          loginBloc.usuario!.tokens =
              loginBloc.usuario!.tokens! - datos.maxtokens;
        }
        add(SetEstaEscribiendo(false));

        return;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");
        add(SetEstaEscribiendo(false));

        return;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");
      add(SetEstaEscribiendo(false));

      return;
    }
  }

  Future getImage(String texto, LoginBloc loginBloc) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/imagebase64",
    );
    final data = {
      "prompt": texto,
      "n": 1,
      "size": "512x512",
      "pro": loginBloc.state.susActive,
      'response_format': "b64_json"
    };

    try {
      add(SetEstaEscribiendo(true));

      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);
        response = respuesta['resp'];

        if (loginBloc.state.susActive == false) {
          loginBloc.usuario!.tokens = loginBloc.usuario!.tokens! - 100;
        }

        add(SetEstaEscribiendo(false));

        return;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");
        add(SetEstaEscribiendo(false));

        return;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");
      add(SetEstaEscribiendo(false));

      return;
    }
  }

  Future getImagesVariation(String path, LoginBloc loginBloc) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/mensajes/variation",
    );

    final data = {
      "image": path,
      "pro": loginBloc.state.susActive,
    };
    try {
      add(SetEstaEscribiendo(true));

      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken()
      });
      if (resp.statusCode == 201) {
        final decode = jsonDecode(resp.body);
        lista.addAll(decode);

        if (loginBloc.state.susActive == false) {
          loginBloc.usuario!.tokens = loginBloc.usuario!.tokens! - 200;
        }

        add(SetEstaEscribiendo(false));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Error Palabra Restringida Intente de Nuevo");
        add(SetEstaEscribiendo(false));
        return;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Intente de Nuevo");
      add(SetEstaEscribiendo(false));
      return;
    }
  }
}
