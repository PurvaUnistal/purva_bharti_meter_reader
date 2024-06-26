// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final int? status;
  final bool? error;
  final String? messages;
  final String? token;
  final User? user;
  final String? exptime;

  LoginModel({
    this.status,
    this.error,
    this.messages,
    this.token,
    this.user,
    this.exptime,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"] ?? "",
        error: json["error"] ?? "",
        messages: json["messages"] ?? "",
        token: json["token"] ?? "",
        user: User.fromJson(json["user"]),
        exptime: json["exptime"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "messages": messages,
        "token": token,
        "user": user!.toJson(),
        "exptime": exptime,
      };
}

class User {
  final String? id;
  final String? email;
  final String? gaId;
  final String? moduleId;
  final String? name;
  final String? userStatus;
  final String? pwdChanged;
  final dynamic modules;
  final String? schema;
  final String? role;
  final String? spreadId;
  final String? sectionId;

  User({
    this.id,
    this.email,
    this.gaId,
    this.moduleId,
    this.name,
    this.userStatus,
    this.pwdChanged,
    this.modules,
    this.schema,
    this.role,
    this.spreadId,
    this.sectionId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? "",
        email: json["email"] ?? "",
        gaId: json["ga_id"] ?? "",
        moduleId: json["module_id"] ?? "",
        name: json["name"] ?? "",
        userStatus: json["user_status"] ?? "",
        pwdChanged: json["pwd_changed"] ?? "",
        modules: json["modules"] ?? "",
        schema: json["schema"] ?? "",
        role: json["role"] ?? "",
        spreadId: json["spread_id"] ?? "",
        sectionId: json["section_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "ga_id": gaId,
        "module_id": moduleId,
        "name": name,
        "user_status": userStatus,
        "pwd_changed": pwdChanged,
        "modules": modules,
        "schema": schema,
        "role": role,
        "spread_id": spreadId,
        "section_id": sectionId,
      };
}
