import 'package:flutter/material.dart';
import './createaccount.dart';
import './homepage.dart';
import './login.dart';
import './addcredentials.dart';
import './editsettings.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesscuro',
      theme: ThemeData(
        canvasColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      //home: const LoginPage(title: 'Login Page'),
      routes: {
        '/': (ctx) => const LoginPage(),
        HomePage.routeName: (ctx) => const HomePage(),
        CreateAccount.routeName: (ctx) => const CreateAccount(),
        LoginPage.routeName: (ctx) => const LoginPage(),
        AddCredentials.routeName:(ctx) => const AddCredentials(),
        EditSettings.routeName:(ctx) => const EditSettings(),
      },
    );
  }
}
