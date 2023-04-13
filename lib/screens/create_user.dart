import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/users/create_user_form.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  static const routeName = '/createAccount';

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  static String message = '';

  void _submitCreateForm(
    String email,
    String password,
    String username,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    final emailUrl = Uri.parse(
        'https://cs.csub.edu/~mbuenonunez/Tesscuro/flutter/email.php');
    var sendEmail = json.encode({'email': email});
    try {
      setState(() {
        _isLoading = true;
      });

      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': email,
      });

      await http.post(emailUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'accept': 'application/json'
          },
          body: sendEmail);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
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
          title: const Text('Add Account'),
        ),
        body: AuthForm(
          submitFn: _submitCreateForm,
          isLoading: _isLoading,
        ));
  }
}
