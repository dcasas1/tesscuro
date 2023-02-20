import 'package:flutter/material.dart';
//import './login.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  static const routeName = '/create-account';

  //Login Page Route popping
  void loginRoute(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            
            //Username Field
            const Padding(
              padding: EdgeInsets.only(
                top: 40,
                left: 10,
                right: 10,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter Username',
                ),
              ),
            ),

            //Email Field
            const Padding(
              padding: EdgeInsets.only(
                top: 40,
                left: 10,
                right: 10,
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter email',
                ),
              ),
            ),

            //Password Field
            const Padding(
              padding: EdgeInsets.only(
                top: 40,
                left: 10,
                right: 10,
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter Password',
                ),
              ),
            ),

            //Password Validation
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
                bottom: 50,
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Re-Enter Password',
                  hintText: 'Re-Enter Password',
                ),
              ),
            ),

            //Submit Button
            SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                onPressed: () => loginRoute(context),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
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
