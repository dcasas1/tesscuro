import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libcrypto/libcrypto.dart';
import '../widgets/passwordGen/pass_gen.dart';

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

  final _urlFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPassFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _passwordController = TextEditingController();
  String _password = '';
  String _siteName = '';
  String _username = '';
  String _url = '';

  //Async function to add account to Firebase on Submit
  Future<void> _addAccount(BuildContext context) async {
    FocusScope.of(context).unfocus();

    //Grabs the ID of the current user logged in
    final user = FirebaseAuth.instance.currentUser!;

    //Validates the form is filled in correctly
    final isValid = _form.currentState?.validate();

    if (!isValid!) {
      return;
    }
    _form.currentState?.save();

    try {
      //Grabs the user information stored in Firebase document
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      //Grabs the password and salt
      final secret = userData['password'];
      final salt =
          Uint8List.fromList(utf8.encode(userData['userID'].toString()));
      //Initializes the password-based key derivation function and creates AES key
      final hasher = Pbkdf2(iterations: 1000);
      final sha256Hash = await hasher.sha256(secret, salt);
      //Grabs password entered in form
      final clearText = _password;
      //Initializes AES encryption in CBC mode and encrypts password
      final aesCbc = AesCbc();
      final cipherText = await aesCbc.encrypt(clearText, secretKey: sha256Hash);

      //Uploads all the information to firebase associated to the user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .add({
        'password': cipherText.toString(),
        'siteName': _siteName,
        'userId': user.uid,
        'username': _username,
        'url': _url,
        'isFavorite': false
      });
    } catch (error) {
      //If error, shows a pop up
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

  //Slides a screen from the bottom to generate password without leaving add account screen
  void _generatePass() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: const GenPass(),
          );
        });
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
              //Site Name field
              TextFormField(
                key: const ValueKey('siteName'),
                keyboardType: TextInputType.text,
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

              //URL for the website
              TextFormField(
                key: const ValueKey('url'),
                keyboardType: TextInputType.url,
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

              //Username field
              TextFormField(
                key: const ValueKey('username'),
                keyboardType: TextInputType.name,
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

              //Password input field
              TextFormField(
                key: const ValueKey('password'),
                keyboardType: TextInputType.visiblePassword,
                //Starts obscured
                obscureText: !_passwordVisible,
                //Stores password in memory while page open for confirmation validation
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password for Site',
                  hintText: 'Enter Password for Site',
                  //Button to dynamically switch if password is obscured
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

              //Confirm password field
              TextFormField(
                key: const ValueKey('confirmPass'),
                keyboardType: TextInputType.visiblePassword,
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

              //Generate Random Password button
              SizedBox.square(
                child: ElevatedButton(
                  onPressed: () {
                    _generatePass();
                  },
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

              //Submit button
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
