import 'package:flutter/material.dart';
import './homepage.dart';

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
      home: const AddCredentials(title: 'Add Credentials'),
    );
  }
}

class AddCredentials extends StatefulWidget {
  const AddCredentials({super.key, required this.title});
  final String title;

  @override
  State<AddCredentials> createState() => _AddCredentialsState();
}

class _AddCredentialsState extends State<AddCredentials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /*Padding(
              padding: EdgeInsets.all(25),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                ),
              ),
            ),*/
            const Padding(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of Site',
                  hintText: 'Enter Name of Site',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL',
                  hintText: 'Enter URL',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username for Site',
                  hintText: 'Enter Username for Site',
                ),
              ),
            ),
            const Padding(
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
            const Padding(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text(
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