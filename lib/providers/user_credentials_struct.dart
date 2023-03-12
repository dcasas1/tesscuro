import 'package:flutter/foundation.dart';

class Accounts with ChangeNotifier {
  final String id;
  final String siteUrl;
  final String password;
  final String userName;

  Accounts(
    this.id,
    this.siteUrl,
    this.password,
    this.userName,
  );
}
