import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './generator.dart';
import './homepage.dart';
import './addcredentials.dart';
import './settings.dart';
import './login.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const routeName = '/nav-bar';

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Map<String, Object>> _pages = const [
    {'page': HomePage(), 'title': 'Homepage'},
    {'page': Settings(), 'title': 'Settings'},
  ];
  void addRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AddCredentials.routeName);
  }

  void loginRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(LoginPage.routeName);
  }

  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(HomePage.routeName);
  }

  void generaterRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(GeneratePassword.routeName);
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        actions: [
          IconButton(
            onPressed: () => addRoute(context),
            icon: const Icon(
              Icons.add,
              size: 31,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.5),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Tesscuro',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: const Text('Home Page'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.lock_reset_outlined,
                color: Colors.grey,
              ),
              title: const Text('Password Generator'),
              onTap: () => generaterRoute(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        showUnselectedLabels: true,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
