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
    required this.mensaje,
    required this.dateTime,
    required this.tipo,
  });
  int? id;
  String de;
  String para;
  String mensaje;
  int dateTime;
  int tipo;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        dateTime: json["dateTime"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "dateTime": dateTime,
        "tipo": tipo,
      };
}
