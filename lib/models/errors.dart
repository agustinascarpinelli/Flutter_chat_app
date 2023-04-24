// To parse this JSON data, do
//
//     final errorsResponse = errorsResponseFromJson(jsonString);

import 'dart:convert';

ErrorsResponse errorsResponseFromJson(String str) =>
    ErrorsResponse.fromJson(json.decode(str));

String errorsResponseToJson(ErrorsResponse data) => json.encode(data.toJson());

class ErrorsResponse {
  ErrorsResponse({
    required this.ok,
    required this.errors,
  });

  bool ok;
  Errors errors;

  factory ErrorsResponse.fromJson(Map<String, dynamic> json) => ErrorsResponse(
        ok: json["ok"],
        errors: Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "errors": errors.toJson(),
      };
}

class Errors {
  Errors(
      {this.password,
      this.passwordConfirmation,
      this.email,
      this.error});

  Email? password;
  Email? passwordConfirmation;
  Email? email;
  String? error;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
      password: json["password"]==null? null :  Email.fromJson(json["password"]),
      passwordConfirmation:json["passwordConfirmation"]==null ? null : Email.fromJson(json["passwordConfirmation"]),
      email:json["email"]==null ? null :  Email.fromJson(json["email"]),
      error: json["error"]??"");

  Map<String, dynamic> toJson() => {
        "password": password!.toJson(),
        "passwordConfirmation": passwordConfirmation!.toJson(),
        "email": email!.toJson(),
      };
}

class Email {
  Email({
    required this.value,
    required this.msg,
    required this.param,
    required this.location,
  });

  String value;
  String msg;
  String param;
  String location;

  factory Email.fromJson(Map<String, dynamic> json) => Email(
        value: json["value"],
        msg: json["msg"],
        param: json["param"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "msg": msg,
        "param": param,
        "location": location,
      };
}
