import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _submitCreateForm(
    String email,
    String password,
    String username,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
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
