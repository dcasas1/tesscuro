import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _submitLoginForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'email': email,
      });
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
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: LoginForm(
          submitFn: _submitLoginForm,
          isLoading: _isLoading,
        ));
  }
}
