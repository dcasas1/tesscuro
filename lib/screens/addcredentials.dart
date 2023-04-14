import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as enc;
import './generator.dart';

class AddCredentials extends StatefulWidget {
  const AddCredentials({super.key});

  static const routeName = '/add-credential';

  @override
  State<AddCredentials> createState() => _AddCredentialsState();
}

class _AddCredentialsState extends State<AddCredentials> {
  //Homepage route
  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  //Generator route
  void generateRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(GeneratePassword.routeName);
  }

  final _urlFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPassFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _passwordController = TextEditingController();
  final key =
      enc.Key.fromBase64('HpQm5JQ8ygKEUeQaYw1YfmpqeD55ySNmc1hT7yUoHhs=');
  final iv = enc.IV.fromBase64('79dKds7g2qXoZEaHzpXokA==');
  String _password = '';
  String _siteName = '';
  String _username = '';
  String _url = '';

  Future<void> _addAccount(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!;
    final isValid = _form.currentState?.validate();

    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(_password, iv: iv);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .add({
        'password': encrypted.base64,
        'siteName': _siteName,
        'userId': user.uid,
        'username': _username,
        'url': _url,
        'isFavorite': false
      });
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx, rootNavigator: true).pop('dialog');
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }
    _controller.clear();

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;
  bool _confirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                key: const ValueKey('siteName'),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of Site',
                  hintText: 'Enter Name of Site',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_urlFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _siteName = value!;
                },
              ),
              Container(
                padding: const EdgeInsets.all(15),
              ),
              TextFormField(
                key: const ValueKey('url'),
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
                padding: const EdgeInsets.all(15),
              ),
              TextFormField(
                key: const ValueKey('username'),
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
                padding: const EdgeInsets.all(15),
              ),
              TextFormField(
                key: const ValueKey('password'),
                obscureText: !_passwordVisible,
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password for Site',
                  hintText: 'Enter Password for Site',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_confirmPassFocusNode);
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              Container(
                padding: const EdgeInsets.all(15),
              ),
              TextFormField(
                key: const ValueKey('confirmPass'),
                obscureText: !_confirmPassVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password for Site',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _confirmPassVisible = !_confirmPassVisible;
                      });
                    },
                    icon: Icon(
                      _confirmPassVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                focusNode: _confirmPassFocusNode,
                onFieldSubmitted: (_) {
                  _addAccount(context);
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
                    _addAccount(context);
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
        ),
      ),
    );
  }
}
