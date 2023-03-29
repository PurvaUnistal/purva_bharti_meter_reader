// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    @required this.status,
    @required this.error,
    @required this.messages,
    @required this.token,
    @required this.user,
    @required this.exptime,
  });

  int? status;
  bool? error;
  String? messages;
  String? token;
  User? user;
  String? exptime;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    error: json["error"],
    messages: json["messages"],
    token: json["token"],
    user: User.fromJson(json["user"]),
    exptime: json["exptime"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "messages": messages,
    "token": token,
    "user": user?.toJson(),
    "exptime": exptime,
  };
}

class User {
  User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.modules,
    @required this.schema,
    @required this.role,
  });

  String? id;
  String? email;
  String? name;
  String? modules;
  String? schema;
  String? role;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    modules: json["modules"],
    schema: json["schema"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "modules": modules,
    "schema": schema,
    "role": role,
  };
}
