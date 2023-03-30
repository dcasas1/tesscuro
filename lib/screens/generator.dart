import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';


class GeneratePassword extends StatelessWidget {
  const GeneratePassword({super.key});

  static const routeName = '/generate-password';

  //Login Page Route popping
  void loginRoute(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Password'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            //Submit Button
            SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                onPressed: () => loginRoute(context),
                child: const Text(
                  'Generate Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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







/*class GeneratePassword extends StatelessWidget {
   GeneratePassword({super.key});

  static const routeName = '/generate-password';

final _controller = TextEditingController();
  
  //Login Page Route popping
  void loginRoute(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Password'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          children: const <Widget>[
           Text("Generate Random Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),  
      ),
    );

  }
      
      
            
            Submit Button
            SizedBox(
              height: 60,
              width: 250,
              child: ElevatedButton(
                onPressed: () => loginRoute(context),
                child: const Text(
                  'Generate Random Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
