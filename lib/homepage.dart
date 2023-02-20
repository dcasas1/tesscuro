import 'package:flutter/material.dart';
import './addcredentials.dart';

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

  // //Nav Bar options
  // int _selectedIndex = 1;
  // static const TextStyle optionStyle = TextStyle(
  //   fontSize: 30,
  //   fontWeight: FontWeight.bold,
  // );
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Settings',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Filters',
  //     style: optionStyle,
  //   ),
  // ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.play_circle_outline),
              title: Text("Youtube"),
              subtitle: Text("Last Login: XX-XX-XXXX"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.play_circle_outline),
              title: Text("FaceBook"),
              subtitle: Text("Last Login: XX-XX-XXXX"),
            ),
          ),
        ],
      ),

      //Add entry Button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => addRoute(context),
        autofocus: true,
        elevation: 15,
        mouseCursor: MaterialStateMouseCursor.textable,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
