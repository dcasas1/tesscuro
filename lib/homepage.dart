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

  //Nav Bar options
  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Settings',
      style: optionStyle,
    ),
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Filters',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),

      //Main Screen List
      body: Column(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.play_circle_outline),
              title: Text("Youtube"),
              subtitle: Text("Last Login: XX-XX-XXXX"),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.play_circle_outline),
              title: Text("FaceBook"),
              subtitle: Text("Last Login: XX-XX-XXXX"),
            ),
          ),
        ],
      ),

      //Add Entry Button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => addRoute(context),
        autofocus: true,
        elevation: 15,
        mouseCursor: MaterialStateMouseCursor.textable,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),

      //Nav Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.line_style),
            label: 'Filters',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
