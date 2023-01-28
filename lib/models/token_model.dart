// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel(
      {required this.titulo,
      required this.tokens,
      required this.value,
      required this.keyData});

  String titulo;
  int tokens;
  String value;
  String keyData;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        titulo: json["titulo"],
        tokens: json["tokens"],
        value: json["value"],
        keyData: json["keyData"],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "tokens": tokens,
        "value": value,
        "keyData": keyData,
      };
}
