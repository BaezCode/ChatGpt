import 'dart:convert';

ChatResponse chatResponseFromJson(String str) =>
    ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
  ChatResponse({
    this.id,
    required this.msg,
    required this.uid,
    required this.lastMsg,
  });
  int? id;
  String msg;
  String uid;
  String lastMsg;

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        id: json["id"],
        msg: json["msg"],
        uid: json["uid"],
        lastMsg: json["lastMsg"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "msg": msg,
        "uid": uid,
        "lastMsg": lastMsg,
      };
}
