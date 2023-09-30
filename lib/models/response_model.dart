// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_gpt/models/msg_response.dart';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    required this.tokens,
    required this.message,
  });
  Message message;
  int tokens;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        message: Message.fromJson(json["message"]),
        tokens: json["tokens"],
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "tokens": tokens,
      };
}
