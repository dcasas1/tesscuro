import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './user_credentials_struct.dart';

class Credentials with ChangeNotifier {
  List<Accounts> _items = [];

  Future<void> fetchAccounts() async {
    final selectAccountUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/selectAccounts.php');
    try {
      final response = await http.get(selectAccountUrl);
      print(jsonDecode(response.body));
    } catch (error) {
      rethrow;
    }
  }
}
