import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

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
  final _passwordController = TextEditingController();
  final _userFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  //Regex validates email, case insensitive with a few metacharacters
  RegExp emailCheck =
      RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-]+)(\.[a-zA-Z]{2,5}){1,2}$');

  //Regex validates password and allows only certain metacharacters
  //Positive lookahead for any character but line break, min 8 characters
  //Only allows metacharacters @$!%*?&
  RegExp passwordCheck = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  //Regex validates username. Only allows letters, numbers, and two metacharacters
  RegExp userCheck = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');
  bool _isVisible = false;

  //Function to run when submit is selected
  void _tryCreateSubmit() {
    //Validates all fields have something valid entered
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

  //Dynamically show and hide password validator widget
  Future<void> showRules() async {
    setState(() {
      _isVisible = !_isVisible;
    });
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
              //Username input field
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
                //Validates username with regex when submitted
                validator: (value) {
                  if (value!.isEmpty || !userCheck.hasMatch(value)) {
                    return 'Please provide a valid username.';
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
              //Email input field
              TextFormField(
                key: const ValueKey('email'),
                //Validates email with regex when submitted
                validator: (value) {
                  if (!emailCheck.hasMatch(value!) || value.isEmpty) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
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

              //When password field selected, validator shows. Hides when deselected
              FocusScope(
                child: Focus(
                  onFocusChange: (value) {
                    showRules();
                  },
                  //Password input field
                  child: TextFormField(
                    onTap: () {},
                    key: const ValueKey('password'),
                    //Validates password with regex when submitted
                    validator: (value) {
                      if (value!.isEmpty || !passwordCheck.hasMatch(value)) {
                        return 'Please enter a valid Password';
                      }
                      return null;
                    },
                    //Stores password in memory while page is open
                    controller: _passwordController,
                    //Starts obscured
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Please enter a strong password',
                      //Icon to dynamically change if password is obscured
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
                ),
              ),
              Visibility(
                visible: _isVisible,
                child: Container(
                  height: 5,
                ),
              ),
              Visibility(
                visible: _isVisible,
                //Password validator with bar under input field
                child: FlutterPwValidator(
                  width: 400,
                  height: 130,
                  minLength: 8,
                  uppercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  successColor: Colors.green,
                  onSuccess: () {},
                  controller: _passwordController,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              //Confirm password field
              TextFormField(
                //Compares value with what is stored in memory on page to validate
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                obscureText: !_confirmPassVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Please confirm your password',
                  //Button to dynamically change if field is obscured
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
                  _tryCreateSubmit();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),

              //Submit button
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
