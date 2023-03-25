import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './user_credentials_struct.dart';

class Credentials with ChangeNotifier {
  List<Accounts> _items = [];

  List<Accounts> get items {
    return [..._items];
  }

  Accounts findById(String id) {
    return _items.firstWhere((account) => account.id == id);
  }

  Future<void> fetchAccounts() async {
    final selectAccountUrl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/selectAccounts.php');
    //Error handling
    try {
      final response = await http.get(selectAccountUrl);
      final receivedData = jsonDecode(response.body);
      //Grabs json data from DB and maps it to a list
      final accountList = List<Accounts>.from(
        receivedData.map((x) => Accounts.fromJson(x)),
      );
      //Grabs the list and insert into the item list to display to screen
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
      'url': account.siteUrl,
      'username': account.userName,
      'password': account.password,
      'siteName': account.siteName,
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
      final newAccount = Accounts(
        id: account.id,
        siteName: account.siteName,
        siteUrl: account.siteUrl,
        password: account.password,
        userName: account.userName,
      );
      _items.add(newAccount);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String id) async {
    final delurl =
        Uri.parse('https://cs.csub.edu/~tesscuro/database/deleteAccount.php');

    //Matches account in current list of accounts based on index
    final existingAccountIndex =
        _items.indexWhere((account) => account.id == id);

    //Grabs the entire account to remove from list
    Accounts? existingAccount = _items[existingAccountIndex];

    //Removes account from list
    _items.removeAt(existingAccountIndex);
    notifyListeners();

    //Grabs ID and encodes as JSON
    var body = json.encode({
      'acc_id': id,
    });

    //Removes account from DB
    final response = await http.post(
      delurl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json'
      },
      body: body,
    );

    //Error handling if unable to delete from DB
    if (response.statusCode >= 400) {
      _items.insert(existingAccountIndex, existingAccount);
      notifyListeners();
      throw const HttpException('Could not delete account.');
    }
    existingAccount = null;
  }

  Future<void> updateProduct(String id, Accounts newAccount) async {
    final accountIndex = _items.indexWhere((account) => account.id == id);
    if (accountIndex >= 0) {
      final url =
          Uri.parse('https://cs.csub.edu/~tesscuro/database/editAccount.php');
      await http.post(
        url,
        body: json.encode({
          'acc_id': newAccount.id,
          'url': newAccount.siteUrl,
          'username': newAccount.userName,
          'password': newAccount.password,
          'siteName': newAccount.siteName,
        }),
      );
      _items[accountIndex] = newAccount;
      notifyListeners();
    } else {
      return;
    }
  }
}
