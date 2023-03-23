import 'package:flutter/foundation.dart';

class Accounts with ChangeNotifier {
  final String id;
  final String siteName;
  final String siteUrl;
  final String password;
  final String userName;

  Accounts({
    required this.id,
    required this.siteName,
    required this.siteUrl,
    required this.password,
    required this.userName,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
        id: json["acc_id"],
        siteName: json["siteName"],
        siteUrl: json["url"],
        password: json["password"],
        userName: json['username'],
      );

  Map<String, dynamic> toJson(Accounts value) => {
        "acc_id": value.id,
        "siteName": value.siteName,
        "url": value.siteUrl,
        "password": value.password,
        "username": value.userName,
      };
}
