import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/credentials.dart';
import '../providers/user_credentials_struct.dart';

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
  var _isLoading = false;
  var _editedAccount = Accounts(
    id: '',
    siteName: '',
    siteUrl: '',
    password: '',
    userName: '',
  );

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Credentials>(context, listen: false)
          .addAccount(_editedAccount);
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
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                        _editedAccount = Accounts(
                            id: _editedAccount.id,
                            siteName: value!,
                            siteUrl: _editedAccount.siteUrl,
                            password: _editedAccount.password,
                            userName: _editedAccount.userName);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    TextFormField(
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
                        _editedAccount = Accounts(
                            id: _editedAccount.id,
                            siteName: _editedAccount.siteName,
                            siteUrl: value!,
                            password: _editedAccount.password,
                            userName: _editedAccount.userName);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    TextFormField(
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
                        _editedAccount = Accounts(
                            id: _editedAccount.id,
                            siteName: _editedAccount.siteName,
                            siteUrl: _editedAccount.siteUrl,
                            password: _editedAccount.password,
                            userName: value!);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password for Site',
                        hintText: 'Enter Password for Site',
                      ),
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        // FocusScope.of(context)
                        //     .requestFocus(_confirmPassFocusNode);
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedAccount = Accounts(
                            id: _editedAccount.id,
                            siteName: _editedAccount.siteName,
                            siteUrl: _editedAccount.siteUrl,
                            password: value!,
                            userName: _editedAccount.userName);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    // TextFormField(
                    //   obscureText: true,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Confirm Password',
                    //     hintText: 'Confirm Password for Site',
                    //   ),
                    //   textInputAction: TextInputAction.done,
                    //   focusNode: _confirmPassFocusNode,
                    //   onSaved: (value) {
                    //     _editedAccount = Accounts(
                    //         id: value!,
                    //         siteName: _editedAccount.siteName,
                    //         siteUrl: _editedAccount.siteUrl,
                    //         password: _editedAccount.password,
                    //         userName: _editedAccount.userName);
                    //   },
                    //   onFieldSubmitted: (_) {
                    //     _saveForm();
                    //   },
                    // ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    SizedBox(
                      height: 60,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _saveForm();
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.black,
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
