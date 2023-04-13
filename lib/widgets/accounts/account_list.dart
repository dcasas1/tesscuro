import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as enc;
import '../../screens/editsettings.dart';

enum AccountOptions {
  passVisible,
  passInvisible,
  editAccount,
  deleteAccount,
}

class AccountList extends StatefulWidget {
  const AccountList({
    super.key,
    required this.siteName,
    required this.userName,
    required this.password,
    required this.docId,
    required this.accountKey,
    required this.isFavorite,
  });

  final Key accountKey;
  final String siteName;
  final String userName;
  final String password;
  final String docId;
  final bool isFavorite;

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  var _passwordVisible = true;
  var newId = '';
  final aesKey =
      enc.Key.fromBase64('HpQm5JQ8ygKEUeQaYw1YfmpqeD55ySNmc1hT7yUoHhs=');
  final iv = enc.IV.fromBase64('79dKds7g2qXoZEaHzpXokA==');

  void _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    newId = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(newId)
        .collection('accounts')
        .doc(widget.docId)
        .delete();
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final encrypter = enc.Encrypter(enc.AES(aesKey));
    final decrypted = encrypter.decrypt64(widget.password, iv: iv);
    return Dismissible(
      key: ValueKey(widget.docId),
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
      onDismissed: (direction) {
        _deleteAccount();
      },
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.star_outline),
          onPressed: () {},
        ),
        horizontalTitleGap: 2,
        title: Text(widget.siteName),
        subtitle: _passwordVisible
            ? Text("Username: ${widget.userName}\nPassword: $decrypted")
            : Text(
                "Username: ${widget.userName}\nPassword: ${widget.password.replaceAll(widget.password, "********")}"),
        trailing: PopupMenuButton(
          onSelected: (AccountOptions selection) {
            setState(() {
              if (selection == AccountOptions.passVisible) {
                _passwordVisible = true;
              } else if (selection == AccountOptions.passInvisible) {
                _passwordVisible = false;
              } else if (selection == AccountOptions.editAccount) {
                Navigator.of(context)
                    .pushNamed(EditSettings.routeName, arguments: widget.docId);
              } else {
                showDialog(
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
                          Navigator.of(ctx).pop();
                          _deleteAccount();
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  ),
                );
              }
            });
          },
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<AccountOptions>>[
            !_passwordVisible
                ? const PopupMenuItem(
                    value: AccountOptions.passVisible,
                    child: Text('Show Password'),
                  )
                : const PopupMenuItem(
                    value: AccountOptions.passInvisible,
                    child: Text('Hide Password'),
                  ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: AccountOptions.editAccount,
              child: Text('Edit Account'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: AccountOptions.deleteAccount,
              child: Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          icon: const Icon(
            Icons.more_vert,
          ),
        ),
      ),
    );
  }
}
