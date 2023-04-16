import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  static const routeName = '/reset';

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _form = GlobalKey<FormState>();
  var _userEmail = '';
  bool _isVisible = true;
  RegExp emailCheck =
      RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-]+)(\.[a-zA-Z]{2,5}){1,2}$');

  void sent() {
    setState(() {
      _isVisible = !_isVisible;
    });
    Timer? returnTimer;
    if (returnTimer != null) {
      returnTimer.cancel();
    }
    returnTimer = Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  void _reset() {
    final isValid = _form.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid!) {
      _form.currentState!.save();
      FirebaseAuth.instance.sendPasswordResetEmail(email: _userEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Your Password'),
      ),
      body: _isVisible
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please enter your email address'),
                Container(
                  height: 8,
                ),
                Form(
                  key: _form,
                  child: TextFormField(
                    key: const ValueKey('email'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email Address',
                    ),
                    textInputAction: TextInputAction.done,
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !emailCheck.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 40,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          _reset();
                          sent();
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
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'Please Check Your Email!',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 30,
                ),
              ),
            ),
    );
  }
}
