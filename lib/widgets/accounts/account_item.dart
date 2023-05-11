import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libcrypto/libcrypto.dart';
import '../../screens/editsettings.dart';

//Fixed values for popup menu
enum AccountOptions {
  passVisible,
  passInvisible,
  editAccount,
  copyPass,
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
  String pass = '';
  var _passwordVisible = false;
  var newId = '';
  bool favorite = false;

  //Grabs and decrypts the password to show on homescreen
  Future<void> _getPass() async {
    //Grabs the ID of the currently logged in user
    final user = FirebaseAuth.instance.currentUser!;
    //Gets the user information
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //Gets the individual account information
    final accountData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(widget.docId)
        .get();
    //Decrypts the password to display on homepage
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

  //Function to delete account
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

  //Function to add or remove as favorite
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
    //Grabs the decrypted password of the account
    _getPass();
    //Displays whether account is a favorite or not
    favorite = widget.isFavorite;

    //Allows swipe to delete
    return Dismissible(
      key: ValueKey(widget.docId),
      direction: DismissDirection.endToStart,
      //Shows confirmation to delete
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
      //Background for swipe action
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
      
      //Tile to display the information
      child: ListTile(
        enabled: true,
        //Allows tap to copy password
        onTap: () {
          Clipboard.setData(ClipboardData(text: pass));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password for ${widget.siteName} Copied!'),
            duration: const Duration(seconds: 2),
          ));
        },
        //Press and hold to edit account
        onLongPress: () => Navigator.of(context).pushNamed(
          EditSettings.routeName,
          arguments: widget.docId,
        ),
        //Favorites icon
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
        //Site name as title
        title: Text(widget.siteName),
        //Password under title. Initially obscured with option to show as plaintext
        subtitle: _passwordVisible
            ? Text("Username: ${widget.userName}\nPassword: $pass")
            : Text(
                "Username: ${widget.userName}\nPassword: ${widget.password.replaceAll(widget.password, "********")}"),
        //Button to bring up more options
        trailing: PopupMenuButton(
          //Different code to run depening on selection made below
          onSelected: (AccountOptions selection) {
            setState(() {
              if (selection == AccountOptions.passVisible) {
                _passwordVisible = true;
              } else if (selection == AccountOptions.passInvisible) {
                _passwordVisible = false;
              } else if (selection == AccountOptions.editAccount) {
                Navigator.of(context)
                    .pushNamed(EditSettings.routeName, arguments: widget.docId);
              } else if (selection == AccountOptions.copyPass) {
                Clipboard.setData(ClipboardData(text: pass));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Password for ${widget.siteName} Copied!'),
                  duration: const Duration(seconds: 2),
                ));
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
          //Builds menu for user to select one
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
              value: AccountOptions.copyPass,
              child: Text("Copy Password"),
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
