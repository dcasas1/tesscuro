import 'package:flutter/material.dart';
import '../widgets/accounts/account_item.dart';
import './addcredentials.dart';
import './editsettings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void addRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AddCredentials.routeName);
  }

  void editRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(EditSettings.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Waits for accounts to be grabbed from backend before loading
      body: Column(
        children: <Widget>[
          const Expanded(
            child: Accounts(),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: Text(
              'Tap \'+\' to add another account!',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
