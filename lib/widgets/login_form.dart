import 'package:flutter/material.dart';
import '../screens/create_user.dart';
import '../screens/password_reset.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.submitFn,
    required this.isLoading,
  });

  final bool isLoading;
  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //Create Account Route
  void createRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CreateAccount.routeName);
  }

  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';
  final _passFocusNode = FocusNode();

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        context,
      );
    }
  }

  @override
  void dispose() {
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Adds Logo to login page
          Padding(
            padding: const EdgeInsets.only(top: 110, bottom: 50),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  child: Image.asset(
                    'assets/img/tesscuro_logo.png',
                    scale: 3,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter Email'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    key: const ValueKey('password'),
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password',
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
                    focusNode: _passFocusNode,
                    textInputAction: TextInputAction.done,
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(PasswordReset.routeName);
                    },
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                  ),

                  //Login Button
                  Center(
                    child: SizedBox(
                      height: 60,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _trySubmit();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            createRoute(context);
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
