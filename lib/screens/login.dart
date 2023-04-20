import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_user.dart';
import './nav_bar.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  //Homepage route
  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(NavBar.routeName);
  }

  //Create Account Route
  void createRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CreateAccount.routeName);
  }

  void _autoLogout() {
    Timer? authTimer; 
    if (authTimer != null) {
      authTimer.cancel();
    }

    authTimer= Timer(
        const Duration(minutes: 30), (() => FirebaseAuth.instance.signOut()));
  }

  void _submitLoginForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    // UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _autoLogout();
    } on FirebaseAuthException catch (err) {
      String message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Tesscuro!'),
        ),
        body: LoginForm(
          submitFn: _submitLoginForm,
          isLoading: _isLoading,
        ));
  }
}
