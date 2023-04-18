import 'package:flutter/material.dart';
import '../widgets/accounts/favorites_list.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});
  static const routeName = '/favorites';

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Expanded(
            child: FavoritesList(),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: Text(
              'All Your Favorited Accounts Here!',
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
