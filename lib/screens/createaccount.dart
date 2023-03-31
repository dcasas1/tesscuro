import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accounts.dart';

import '../providers/user_accounts.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  static const routeName = '/create-account';

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //Login Page Route popping
  void loginRoute(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  final _userFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _newAccount = Users(
    id: '',
    userName: '',
    email: '',
    pass: '',
  );

  @override
  void dispose() {
    _userFocusNode.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm(BuildContext context) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<UserAccounts>(context, listen: false)
          .addAccount(_newAccount);
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

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  bool? _passwordVisible;
  bool? _confirmPassVisible;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPassVisible = false;
    super.initState();
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
                        labelText: 'Enter Username',
                        hintText: 'Enter a username to use',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newAccount = Users(
                            id: _newAccount.id,
                            userName: value!,
                            email: _newAccount.email,
                            pass: _newAccount.pass);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter an email address',
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passFocusNode);
                      },
                      onSaved: (value) {
                        _newAccount = Users(
                            id: _newAccount.id,
                            userName: _newAccount.userName,
                            email: value,
                            pass: _newAccount.pass);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    TextFormField(
                      obscureText: !_passwordVisible!,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Please enter a strong password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible!;
                            });
                          },
                          icon: Icon(
                            _passwordVisible!
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _passFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_confirmFocusNode);
                      },
                      onSaved: (value) {
                        _newAccount = Users(
                            id: _newAccount.id,
                            userName: _newAccount.userName,
                            email: _newAccount.email,
                            pass: value!);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    TextFormField(
                      obscureText: !_confirmPassVisible!,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        hintText: 'Please confirm your password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmPassVisible = !_confirmPassVisible!;
                            });
                          },
                          icon: Icon(
                            _confirmPassVisible!
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      focusNode: _confirmFocusNode,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm(context);
                      },
                      onSaved: (value) {},
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    SizedBox(
                      height: 60,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _saveForm(context);
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
