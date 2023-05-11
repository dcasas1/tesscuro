import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
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
  //Creates an instance in Firebase
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  //Function to run once the form is submitted successfully in the widget
  void _submitCreateForm(
    String email,
    String password,
    String username,
    BuildContext ctx,
  ) async {
    //Grabs the current instance in Firebase
    UserCredential authResult;

    //Generates a cryptographically secure number to make a salt
    Random random = Random.secure();
    int randomNumber = random.nextInt(1000000000);

    //Encodes the entered password into utf8 then hashes with sha256
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    //Sets up email to user
    final emailUrl = Uri.parse(
        'https://cs.csub.edu/~mbuenonunez/Tesscuro/flutter/email.php');
    var sendEmail = json.encode({'email': email});

    try {
      setState(() {
        _isLoading = true;
      });

      //Creates user and stores password with SCRYPT hash algorithm on Firebase
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Stores user information on Firebase with SHA256 hashed password
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': email,
        'password': digest.toString(),
        'userID': randomNumber,
      });

      //Sends email only if account was created and stored successfully in prior steps
      await http.post(emailUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'accept': 'application/json'
          },
          body: sendEmail);

      //Returns to login page then auto logs user in
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (err) {
      String message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }
      //Shows popup on bottom of screen if error occurs
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
        //Body loads create_user_form widget and passes the submit function for use
        body: AuthForm(
          submitFn: _submitCreateForm,
          isLoading: _isLoading,
        ));
  }
}
