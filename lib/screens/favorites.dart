import 'package:flutter/material.dart';
import '../widgets/accounts/account_list.dart';
//import './generator.dart';
//import '../main.dart';
//import './create_user.dart';

class Favorites extends StatefulWidget {
  //const Favorites({required Key key}) : super(key: key);
  const Favorites({super.key});
  static const routeName = '/favorites';

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
            //child: Text(
            //'Tap \'+\' to add another account!',
            //style: TextStyle(
            //fontSize: 18,
            //color: Theme.of(context).colorScheme.primary,
            //),
            //),
          ),
        ],
      ),
    );
  }
}
