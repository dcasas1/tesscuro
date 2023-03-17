import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import './account_item.dart';
import '../providers/credentials.dart';

class AccountsGrid extends StatelessWidget {
  const AccountsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final accountsData = Provider.of<Credentials>(context);
    final accounts = accountsData.items;
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      separatorBuilder: (context, index) => const Divider(
        thickness: 2,
        color: Colors.grey,
      ),
      itemCount: accounts.length,
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            value: accounts[index],
            child: const AccountView(),
          )),
    );
  }
}
