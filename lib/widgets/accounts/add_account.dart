import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  void _addAccount() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('accounts').add({
      'password': userData['password'],
      'siteName': userData['siteName'],
      'userId': user.uid,
      'username': userData['username'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      padding: const EdgeInsets.all(
        8,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _addAccount,
            icon: const Icon(
              Icons.send,
            ),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
