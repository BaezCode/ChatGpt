import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/global/enviroment.dart';
import 'package:chat_gpt/models/login_response.dart';
import 'package:chat_gpt/models/usuario_model.dart';
import 'package:chat_gpt/services/google_sigin_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Usuario? usuario;
  var uid = const Uuid();

  FlutterSecureStorage storage = const FlutterSecureStorage();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  //Tokens y Logout
  Future guardarToken(String token) async {
    return await storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  //Login - Regitro
  Future register(
    String email,
    String password,
  ) async {
    final data = {'email': email, 'password': password, 'idAssist': uid.v4()};
    final uri = Uri.parse(
      "${Environment.apiUrl}/login/new",
    );
    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await guardarToken(loginResponse.token);
        return true;
      } else {
        final respBody = jsonDecode(resp.body);
        return respBody['msg'];
      }
    } catch (e) {
      return e;
    }
  }

  // login Normal

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };
    final uri = Uri.parse(
      "${Environment.apiUrl}/login",
    );
    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await guardarToken(loginResponse.token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //Login Con Google
  Future<bool> loginGoogle() async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/login/google",
    );
    try {
      final data = {
        'id_token': await GoogleSignInService.signInWithGoogle(),
        'idAssist': uid.v4()
      };
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await guardarToken(loginResponse.token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Mantener logueado
  Future<bool> isLoggedIn() async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/login/renew",
    );
    final token = await storage.read(key: 'token') ?? '';

    try {
      final resp = await http.get(uri,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await guardarToken(loginResponse.token);
        return true;
      } else {
        logout();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getReward(num reward) async {
    final uri = Uri.parse(
      "${Environment.apiUrl}/login/reward",
    );
    final data = {
      "reward": reward,
    };
    final token = await storage.read(key: 'token') ?? '';

    try {
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        final respuesta = jsonDecode(resp.body);
        usuario!.tokens = respuesta['token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
