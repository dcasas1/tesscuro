import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_credentials_struct.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  var _passwordVisible = true;

  @override
  void initState() {
    _passwordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Accounts>(context, listen: false);
    return ListTile(
      title: Text(account.siteName),
      subtitle: _passwordVisible
          ? Text(
              "Username: ${account.userName}\nPassword: ${account.password.replaceAll(account.password, "********")}")
          : Text(
              "Username: ${account.userName}\nPassword: ${account.password}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
