import 'dart:convert';

User userFromJSON(String str) => User.fromJson(json.decode(str));

String userToJSON(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], username: json["username"], email: json["email"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
  };
}
