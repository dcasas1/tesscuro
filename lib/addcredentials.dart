import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const CreateAccount(title: 'Add Site Settings'),
    );
  }
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key, required this.title});
  final String title;

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            /*Padding(
              padding: EdgeInsets.all(25),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                ),
              ),
            ),*/
            Padding(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of Site',
                  hintText: 'Enter Name of Site',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL',
                  hintText: 'Enter URL',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username for Site',
                  hintText: 'Enter Username for Site',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password for Site',
                  hintText: 'Enter Password for Site',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom:50),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password for Site',
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}