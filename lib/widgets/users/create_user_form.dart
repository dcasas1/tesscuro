import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.submitFn,
    required this.isLoading,
  });

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  final _userFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  void _tryCreateSubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        context,
      );
    }
  }

  @override
  void dispose() {
    _userFocusNode.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;
  bool _confirmPassVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPassVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                key: const ValueKey('username'),
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
                  _userName = value!;
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              TextFormField(
                key: const ValueKey('email'),
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
                  _userEmail = value!;
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              TextFormField(
                key: const ValueKey('password'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 8) {
                    return 'Password must be at lease 8 characters long.';
                  }
                  return null;
                },
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Please enter a strong password',
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
                textInputAction: TextInputAction.next,
                focusNode: _passFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_confirmFocusNode);
                },
                onSaved: (value) {
                  _userPassword = value!;
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              TextFormField(
                obscureText: !_confirmPassVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Please confirm your password',
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
                focusNode: _confirmFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  //_saveForm(context);
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    _tryCreateSubmit();
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
