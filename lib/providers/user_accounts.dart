import 'package:flutter/material.dart';

class Users with ChangeNotifier {
  final String id;
  final String userName;
  final String? email;
  String pass;

  Users({
    required this.id,
    required this.userName,
    required this.email,
    required this.pass,
  });

  @override
  toString() {
    return '{cus_id: $id, userName: $userName, email: $email, password: $pass}';
  }

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["cus_id"],
        userName: json["userName"],
        email: json["email"],
        pass: json["password"],
      );

  Map<String, dynamic> toJson(Users value) => {
        "cus_id": value.id,
        "userName": value.userName,
        "email": value.email,
        "password": value.pass,
      };
}
