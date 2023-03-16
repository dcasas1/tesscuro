import 'package:flutter/foundation.dart';

class Accounts with ChangeNotifier {
  final int? id;
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
        id: json["cID"],
        siteName: json["siteName"],
        siteUrl: json["url"],
        password: json["password"],
        userName: json['username'],
      );

  Map<String, dynamic> toJson() => {
        "cID": id,
        "siteName": siteName,
        "url": siteUrl,
        "password": password,
        "username": userName,
      };
}
