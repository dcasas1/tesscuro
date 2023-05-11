import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libcrypto/libcrypto.dart';
import './nav_bar.dart';
import '../widgets/passwordGen/pass_gen.dart';

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
  String pass = '';
  var newId = '';
  bool _isInit = true;

  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(NavBar.routeName);
  }

  final _urlFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;

  //Function to decrypt password to autofill current password field
  Future<void> getPass() async {
    //Grabs the ID of the currently logged in user
    final user = FirebaseAuth.instance.currentUser!;
    //Accepts the document ID passed as an argument to select the correct account
    final docId = ModalRoute.of(context)!.settings.arguments as String;
    //Grabs the user data from Firebase
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //Grabs the selected account's data from Firebase
    final accountData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(docId)
        .get();
    //Grabs the user's hashed password
    final secret = userData['password'];
    //Grabs the salt
    final salt = Uint8List.fromList(utf8.encode(userData['userID'].toString()));
    //Initialized the password based key derivation function
    final hasher = Pbkdf2(iterations: 1000);
    //Creates the AES key
    final sha256Hash = await hasher.sha256(secret, salt);
    //Initializes AES in CBC mode
    final aesCbc = AesCbc();
    //Decrypts password
    final decrypted =
        await aesCbc.decrypt(accountData['password'], secretKey: sha256Hash);
    //Ensures function runs once to fill in the current password field
    if (_isInit) {
      if (mounted) {
        setState(() {
          pass = decrypted;
        });
      }
    }
    _isInit = false;
  }

  //Function to grab selected account's information to autofill all the form fields
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

  //Function to delete the account if button is selected
  void deleteAccount(BuildContext context) async {
    final docId = ModalRoute.of(context)!.settings.arguments as String;
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(docId)
        .delete();

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  //Function to update account on Firebase if submitted
  void _updateAccount(BuildContext context) async {
    FocusScope.of(context).unfocus();
    //Grabs selected account's ID that was passed as an argument
    final docId = ModalRoute.of(context)!.settings.arguments as String;
    //Validates all fields are filled in and valid
    final isValid = _form.currentState?.validate();
    //Grabs logged in user's ID
    final user = FirebaseAuth.instance.currentUser!;

    //If form is invalid, throws errors
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //Encrypts password submitted to upload ciphertext
    final secret = userData['password'];
    final salt = Uint8List.fromList(utf8.encode(userData['userID'].toString()));
    final hasher = Pbkdf2(iterations: 1000);
    final sha256Hash = await hasher.sha256(secret, salt);
    final clearText = _password;
    final aesCbc = AesCbc();
    final cipherText = await aesCbc.encrypt(clearText, secretKey: sha256Hash);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newId)
        .collection('accounts')
        .doc(docId)
        .update({
      'siteName': _siteName,
      'url': _url,
      'username': _username,
      'password': cipherText.toString(),
    });

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(NavBar.routeName);
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
  Widget build(BuildContext context) {
    //Decrypts the password of the selected account to autofill below
    getPass();
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Settings')),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        //Waits for data to be grabbed before building UI
        child: FutureBuilder(
          future: getData(),
          builder: (context, querySnapshot) {
            //Loading circle while information is grabbed
            if (querySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  //Site Name Input Field
                  TextFormField(
                    //Autofills with current site name of account selected
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

                  //URL input field
                  TextFormField(
                    //Autofills with current url of account selected
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

                  //Username input field
                  TextFormField(
                    //Autofills with current username of account selected
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

                  //Password input field
                  TextFormField(
                    //Autofills with decrypted password of currently selected account
                    initialValue: pass,
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

                  //Generate Password button
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

                  Container(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 15,
                    ),
                  ),

                  //Delete Account Button
                  ElevatedButton(
                    onPressed: () {
                      //Shows confirmation popup dialog if selected
                      showDialog(
                        context: context,
                        builder: ((ctx) => AlertDialog(
                              title: const Text(
                                'Are you sure?',
                              ),
                              content: const Text(
                                'Do you want to remove this account?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    deleteAccount(context);
                                  },
                                  child: const Text('Yes'),
                                )
                              ],
                            )),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 20),
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
