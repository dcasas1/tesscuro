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
  //The user instance
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

  //Function to start a 30 minute timer. Logs user out after 30 minutes
  void _autoLogout() {
    Timer? authTimer;
    //Check if timer is already running. If so, cancels and then restarts below
    if (authTimer != null) {
      authTimer.cancel();
    }

    authTimer = Timer(
        const Duration(minutes: 30), (() => FirebaseAuth.instance.signOut()));
  }

  //Function to run when Login button is submitted successfully
  void _submitLoginForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Start logout timer if successfully logged in
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
        //Body loads the login_form widget
        body: LoginForm(
          submitFn: _submitLoginForm,
          isLoading: _isLoading,
        ));
  }
}
