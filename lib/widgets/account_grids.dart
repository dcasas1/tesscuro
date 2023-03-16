import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../providers/credentials.dart';

class AccountsGrid extends StatelessWidget {
  const AccountsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final accountsData = Provider.of<Credentials>(context);
    final accounts = accountsData.items;
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: ((context, index) =>
          ChangeNotifierProvider.value(value: accounts[index])),
    );
  }
}
