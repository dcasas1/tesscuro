import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libcrypto/libcrypto.dart';
import '../../screens/editsettings.dart';

enum AccountOptions {
  passVisible,
  passInvisible,
  editAccount,
  deleteAccount,
}

class FavItems extends StatefulWidget {
  const FavItems({
    super.key,
    required this.accountKey,
    required this.siteName,
    required this.userName,
    required this.password,
    required this.docId,
    required this.isFavorite,
  });

  final Key accountKey;
  final String siteName;
  final String userName;
  final String password;
  final String docId;
  final bool isFavorite;

  @override
  State<FavItems> createState() => _FavItemsState();
}

class _FavItemsState extends State<FavItems> {
  var _passwordVisible = false;
  var newId = '';
  bool favorite = false;
  String pass = '';

  Future<void> _getPass() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final accountData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(widget.docId)
        .get();
    final secret = userData['password'];
    final salt = Uint8List.fromList(utf8.encode(userData['userID'].toString()));
    final hasher = Pbkdf2(iterations: 1000);
    final sha256Hash = await hasher.sha256(secret, salt);
    final aesCbc = AesCbc();
    final decryptedText =
        await aesCbc.decrypt(accountData['password'], secretKey: sha256Hash);
    if (mounted) {
      setState(() {
        pass = decryptedText;
      });
    }
  }

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

  void _updateFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    newId = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(newId)
        .collection('accounts')
        .doc(widget.docId)
        .update({'isFavorite': favorite});
  }

  @override
  Widget build(BuildContext context) {
    _getPass();
    favorite = widget.isFavorite;
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
        enabled: true,
        onTap: () {
          Clipboard.setData(ClipboardData(text: pass));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password ${widget.siteName} Copied!'),
            duration: const Duration(seconds: 2),
          ));
        },
        onLongPress: () => Navigator.of(context).pushNamed(
          EditSettings.routeName,
          arguments: widget.docId,
        ),
        leading: favorite
            ? IconButton(
                alignment: const Alignment(-1, 0),
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {
                  favorite = !favorite;
                  _updateFavorite();
                },
                icon: const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 231, 210, 19),
                ),
              )
            : IconButton(
                alignment: const Alignment(-1, 0),
                padding: const EdgeInsets.only(right: 10),
                icon: const Icon(Icons.star_outline),
                onPressed: () {
                  favorite = !favorite;
                  _updateFavorite();
                },
              ),
        horizontalTitleGap: 2,
        title: Text(widget.siteName),
        subtitle: _passwordVisible
            ? Text("Username: ${widget.userName}\nPassword: $pass")
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
