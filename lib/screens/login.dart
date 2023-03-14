import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './createaccount.dart';
import './nav_bar.dart';
import '../providers/credentials.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  Future<void> _setAccounts(BuildContext context) async {
    await Provider.of<Credentials>(context, listen: false).fetchAccounts();
  }

  //Homepage route
  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(NavBar.routeName);
  }

  //Create Account Route
  void createRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CreateAccount.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Adds Logo to login page
            Padding(
              padding: const EdgeInsets.only(top: 110, bottom: 50),
              child: Center(
                child: SizedBox(
                  child: Image.asset(
                    'assets/img/tesscuro_logo.png',
                    scale: 3,
                  ),
                ),
              ),
            ),

            //Adds Username Field
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter Username',
                ),
              ),
            ),

            //Adds Password Field
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter password',
                ),
              ),
            ),

            //Login Button
            SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  _setAccounts(context);
                  homeRoute(context);
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),

            //Create Account Button
            Padding(
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
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
