// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        required this.name,
        required this.email,
        required this.uid,
        required this.online,
        required this.friends,
    });

    String name;
    String email;
    String uid;
    bool online;
    List<dynamic> friends;

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        uid: json["uid"],
        online: json["online"],
        friends: List<dynamic>.from(json["friends"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "uid": uid,
        "online": online,
        "friends": List<dynamic>.from(friends.map((x) => x)),
    };
}
