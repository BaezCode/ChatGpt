// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    this.id,
    required this.de,
    required this.para,
    required this.tokens,
    required this.mensaje,
    required this.dateTime,
    required this.tipo,
  });
  int? id;
  String de;
  String para;
  int tokens;
  String mensaje;
  int dateTime;
  int tipo;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        de: json["de"],
        para: json["para"],
        tokens: json["tokens"],
        mensaje: json["mensaje"],
        dateTime: json["dateTime"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "de": de,
        "para": para,
        "tokens": tokens,
        "mensaje": mensaje,
        "dateTime": dateTime,
        "tipo": tipo,
      };
}
