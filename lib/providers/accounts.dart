import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './user_accounts.dart';

class UserAccounts with ChangeNotifier {
  Future<void> addAccount(Users user) async {
    final addUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/addUser.php');
    var bytes = utf8.encode(user.pass);
    var digest = sha256.convert(bytes);
    var body = json.encode({
      'userName': user.userName,
      'email': user.email,
      'password': digest.toString(),
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
