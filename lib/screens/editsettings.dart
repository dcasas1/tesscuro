import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as enc;
import './nav_bar.dart';
import './generator.dart';

class EditSettings extends StatefulWidget {
  const EditSettings({
    super.key,
  });
  static const routeName = '/edit-settings';

  @override
  State<EditSettings> createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  final _form = GlobalKey<FormState>();
  String _password = '';
  String _siteName = '';
  String _username = '';
  String _url = '';
  var newId = '';

  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(NavBar.routeName);
  }

  void generateRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(GeneratePassword.routeName);
  }

  final _urlFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final aesKey =
      enc.Key.fromBase64('HpQm5JQ8ygKEUeQaYw1YfmpqeD55ySNmc1hT7yUoHhs=');
  final iv = enc.IV.fromBase64('79dKds7g2qXoZEaHzpXokA==');

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;

  Future<DocumentSnapshot> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    newId = user!.uid;
    final docId = ModalRoute.of(context)!.settings.arguments as String;

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(newId)
        .collection('accounts')
        .doc(docId)
        .get();
  }

  void _updateAccount(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final docId = ModalRoute.of(context)!.settings.arguments as String;
    final isValid = _form.currentState?.validate();

    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newId)
        .collection('accounts')
        .doc(docId)
        .update({
      'siteName': _siteName,
      'url': _url,
      'username': _username,
      'password': _password,
    });

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(NavBar.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final encrypter = enc.Encrypter(enc.AES(aesKey));
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Settings')),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        child: FutureBuilder(
          future: getData(),
          builder: (context, querySnapshot) {
            if (querySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final decrypted =
                encrypter.decrypt64(querySnapshot.data!['password'], iv: iv);
            return Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: querySnapshot.data!['siteName'],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name of Site',
                      hintText: 'Site Name',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_urlFocusNode);
                    },
                    onSaved: (value) {
                      _siteName = value!;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                  ),
                  TextFormField(
                    initialValue: querySnapshot.data!['url'],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'URL',
                      hintText: 'Enter URL',
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _urlFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_usernameFocusNode);
                    },
                    onSaved: (value) {
                      _url = value!;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                  ),
                  TextFormField(
                    initialValue: querySnapshot.data!['username'],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter Username',
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _usernameFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                  ),
                  TextFormField(
                    initialValue: decrypted,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password for Site',
                        hintText: 'Enter Password for Site',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _updateAccount(context);
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 10,
                    ),
                  ),
                  SizedBox.square(
                    //height: 50,
                    //width: 150,
                    child: ElevatedButton(
                      onPressed: () => generateRoute(context),
                      child: const Text(
                        'Generate Random Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 15,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateAccount(context);
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
