import 'dart:convert';

import 'package:classroom_app/models/user.dart';

AuthResponse authFromJSON(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authToJSON(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  final String message;
  final String? token;
  final User? user;

  AuthResponse({required this.message, this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    message: json["message"],
    token: json["token"],
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "user": user,
  };
}
