import 'package:flutter/material.dart';
import './nav_bar.dart';

class EditSettings extends StatelessWidget {
  const EditSettings({super.key});

  static const routeName = 'edit-settings';

  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(NavBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Site name field
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
              hintText: 'Site Name',
            ),
          ),
        ),

        //URL Field
        const Padding(
          padding: EdgeInsets.only(
            top: 40,
            left: 10,
            right: 10,
          ),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'URL',
              hintText: 'URL',
            ),
          ),
        ),

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
              labelText: 'Username of Site',
              hintText: 'Username',
            ),
          ),
        ),

        //Password Field
        const Padding(
          padding: EdgeInsets.only(
            top: 40,
            left: 10,
            right: 10,
            bottom: 50,
          ),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Password',
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
    );
  }
}
