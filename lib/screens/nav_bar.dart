import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesscuro/screens/favorites.dart';
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
  //Pages to load from the Navbar
  final List<Map<String, Object>> _pages = const [
    {'page': HomePage(), 'title': 'Homepage'},
    {'page': Favorites(), 'title': 'Favorites'},
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

  void favoritesRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(Favorites.routeName);
  }

  //Start on homepage
  int _selectedPageIndex = 0;

  //Update which page to load when selecting one
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Title dynamically changes based on selected page
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        actions: [
          //Button to go to add account screen
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
      //Hamburger Icon for an app drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //Title in app drawer 
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

            //Home Page button
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: const Text('Home Page'),
              onTap: () {
                _selectPage(0);
                Navigator.of(context).pop();
              },
            ),

            //Favorites button
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: const Text('Favorites'),
              onTap: () {
                _selectPage(1);
                Navigator.of(context).pop();
              },
            ),

            //Password Generator button
            ListTile(
              leading: const Icon(
                Icons.lock_reset_outlined,
                color: Colors.grey,
              ),
              title: const Text('Password Generator'),
              onTap: () => generaterRoute(context),
            ),

            //Logout button
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      //Loads the page selected
      body: _pages[_selectedPageIndex]['page'] as Widget,
      //Creates the navbar on the bottom of the screen
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        showUnselectedLabels: true,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
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
