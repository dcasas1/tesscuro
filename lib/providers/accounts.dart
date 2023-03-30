import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './user_accounts.dart';

class UserAccounts with ChangeNotifier {
  Future<void> addAccount(Users user) async {
    final addUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/addUser.php');
    var body = json.encode({
      'userName': user.userName,
      'email': user.email,
      'password': user.pass,
    });
    try {
      await http.post(
        addUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json'
        },
        body: body,
      );
    } catch (error) {
      rethrow;
    }
  }
}
