// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.estado,
    required this.idAssist,
    this.refresh,
    this.google,
    this.apple,
    required this.email,
    required this.tokens,
    required this.uid,
  });

  bool? estado;
  String idAssist;
  String? refresh;
  String uid;
  bool? google;
  bool? apple;
  int? tokens;
  String email;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        estado: json["estado"],
        idAssist: json["idAssist"],
        refresh: json["refresh"],
        google: json["google"],
        apple: json["apple"],
        tokens: json["tokens"],
        email: json["email"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "idAssist": idAssist,
        "refresh": refresh,
        "google": google,
        "apple": apple,
        "tokens": tokens,
        "email": email,
        "uid": uid,
      };
}
