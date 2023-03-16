import 'package:flutter/foundation.dart';

class Accounts with ChangeNotifier {
  final String id;
  final String siteUrl;
  final String password;
  final String userName;

  Accounts({
    required this.id,
    required this.siteUrl,
    required this.password,
    required this.userName,
  });
}
