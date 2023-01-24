// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    required this.estado,
    required this.idAssist,
    this.google,
    this.apple,
    required this.email,
    required this.tokens,
    required this.uid,
  });

  String estado;
  String idAssist;
  String uid;
  bool? google;
  bool? apple;
  int? tokens;
  String email;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        estado: json["estado"],
        idAssist: json["idAssist"],
        google: json["google"],
        apple: json["apple"],
        tokens: json["tokens"],
        email: json["email"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "idAssist": idAssist,
        "google": google,
        "apple": apple,
        "tokens": tokens,
        "email": email,
        "uid": uid,
      };
}
