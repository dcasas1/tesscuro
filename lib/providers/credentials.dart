import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './user_credentials_struct.dart';

class Credentials with ChangeNotifier {
  List<Accounts> _items = [];

  List<Accounts> get items {
    return [..._items];
  }

  Future<void> fetchAccounts() async {
    final selectAccountUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/selectAccounts.php');
    try {
      final response = await http.get(selectAccountUrl);
      Map<String, dynamic> receivedData =
          Map<String, dynamic>.from(json.decode(response.body));
      final List<Accounts> loadedData = [];
      receivedData.forEach((accountID, data) {
        loadedData.add(
          Accounts(
            id: data['cID'],
            siteUrl: data['url'],
            password: data['password'],
            userName: data['username'],
          ),
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addAccount(Accounts account) async {
    final addUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/addAccount.php');
    try {
      final response = await http.post(
        addUrl,
        body: json.encode({
          'cID': account.id,
          'url': account.siteUrl,
          'username': account.userName,
          'password': account.password,
        }),
      );
    } catch (error) {
      rethrow;
    }
  }
}
