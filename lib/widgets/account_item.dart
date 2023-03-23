import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/credentials.dart';

import '../providers/user_credentials_struct.dart';
import '../screens/editsettings.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  var _passwordVisible = true;
  void editRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(EditSettings.routeName);
  }

  @override
  void initState() {
    _passwordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Accounts>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    return Dismissible(
      key: ValueKey(account.siteUrl),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Are you sure?',
            ),
            content: const Text(
              'Do you want to remove this account?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) async {
        try {
          await Provider.of<Credentials>(context, listen: false)
              .deleteAccount(account.id);
        } catch (error) {
          scaffold.showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to delete Account',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: ListTile(
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
          ],
        ),
      ),
    );
  }
}
