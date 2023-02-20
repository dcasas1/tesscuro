import 'package:flutter/material.dart';
//import './homepage.dart';

class AddCredentials extends StatelessWidget {
  const AddCredentials({super.key});

  static const routeName = 'add-credential';

  //Homepage route
  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.all(25),
            //   child: Center(
            //     child: SizedBox(
            //       width: 200,
            //       height: 150,
            //     ),
            //   ),
            // ),

            //Site Name input
            const Padding(
              padding: EdgeInsets.only(
                top: 40,
                left: 10,
                right: 10,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of Site',
                  hintText: 'Enter Name of Site',
                ),
              ),
            ),

            //URL Input
            const Padding(
              padding: EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL',
                  hintText: 'Enter URL',
                ),
              ),
            ),

            //Username Input
            const Padding(
              padding: EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username for Site',
                  hintText: 'Enter Username for Site',
                ),
              ),
            ),

            //Password Input
            const Padding(
              padding: EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password for Site',
                  hintText: 'Enter Password for Site',
                ),
              ),
            ),

            //Password validation
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
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password for Site',
                ),
              ),
            ),

            //Submit Button
            SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                onPressed: () => homeRoute(context),
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
