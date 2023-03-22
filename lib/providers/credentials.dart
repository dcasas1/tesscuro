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
      final receivedData = jsonDecode(response.body);
      print(receivedData);
      final accountList = List<Accounts>.from(
        receivedData.map((x) => Accounts.fromJson(x)),
      );
      _items = accountList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addAccount(Accounts account) async {
    final addUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/addAccount.php');
    var body = json.encode({
      'cID': account.id,
      'url': account.siteUrl,
      'username': account.userName,
      'password': account.password,
      'siteName': account.siteName,
    });
    print(body);
    try {
      final http.Response response = await http.post(
        addUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json'
        },
        body: body,
      );
      print('body: [${response.body}]');

      final newAccount = Accounts(
        id: account.id,
        siteName: account.siteName,
        siteUrl: account.siteUrl,
        password: account.password,
        userName: account.userName,
      );
      _items.insert(0, newAccount);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
