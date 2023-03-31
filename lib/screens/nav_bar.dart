import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './generator.dart';
import './homepage.dart';
import './addcredentials.dart';
import '../providers/credentials.dart';
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

  Future<void> _refreshAccounts(BuildContext context) async {
    await Provider.of<Credentials>(context, listen: false).fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(Icons.menu),
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        actions: [
          IconButton(
            onPressed: () {
              if (_selectedPageIndex == 0) {
                _refreshAccounts(context);
              } else {
                _refreshAccounts(context);
                Navigator.of(context).pushReplacementNamed(NavBar.routeName);
              }
            },
            icon: const Icon(
              Icons.refresh,
              size: 31,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
          ),
          IconButton(
            onPressed: () => addRoute(context),
            icon: const Icon(
              Icons.add,
              size: 31,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
          ),
        ],
      ), //AppBar(
      //leading: const Icon(Icons.menu),
      //title: Text(_pages[_selectedPageIndex]['title'] as String),

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
                Icons.circle_outlined,
              ),
              title: const Text('Other Page For Now'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: const Text('Logout'),
              onTap: () => loginRoute(context)
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
