import 'dart:convert';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

class AppleSignInService {
  static Future<bool> sigIn(BuildContext context) async {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    var uid = const Uuid();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
      ]);

      final siginWithAppleEnpoint = Uri(
          scheme: 'https',
          host: 'chatbot-app.herokuapp.com',
          path: 'api/login/sign_in_with_apple',
          queryParameters: {
            'idAssist': uid.v4(),
            'code': credential.authorizationCode,
            'firstName': credential.givenName,
            'lastName': credential.familyName,
            'useBundleId': 'true',
            if (credential.state != null) 'state': credential.state
          });

      final resp = await http.post(siginWithAppleEnpoint);
      final loginResponse = loginResponseFromJson(resp.body);
      await loginBloc.guardarToken(loginResponse.token);
      return true;
    } catch (e) {
      return false;
    }
  }
}
