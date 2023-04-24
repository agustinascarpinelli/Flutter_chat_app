// To parse this JSON data, do
//
//     final messagesResponse = messagesResponseFromJson(jsonString);

import 'dart:convert';

MessagesResponse messagesResponseFromJson(String str) => MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) => json.encode(data.toJson());

class MessagesResponse {
    MessagesResponse({
        required this.ok,
        required this.msg,
        required this.myId,
        required this.messagesFrom,
    });

    bool ok;
    List<Msg> msg;
    String myId;
    String messagesFrom;

    factory MessagesResponse.fromJson(Map<String, dynamic> json) => MessagesResponse(
        ok: json["ok"],
        msg: List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))),
        myId: json["myId"],
        messagesFrom: json["messagesFrom"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
        "myId": myId,
        "messagesFrom": messagesFrom,
    };
}

class Msg {
    Msg({
        required this.from,
        required this.to,
        required this.msg,
        required this.createdAt,
        required this.updatedAt,
    });

    String from;
    String to;
    String msg;
    DateTime createdAt;
    DateTime updatedAt;

    factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        from: json["from"],
        to: json["to"],
        msg: json["msg"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "msg": msg,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
