import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './homepage.dart';
import './editsettings.dart';
import './addcredentials.dart';
import '../providers/credentials.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const routeName = '/nav-bar';

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Map<String, Object>> _pages = const [
    {'page': HomePage(), 'title': 'Homepage'},
    {'page': EditSettings(), 'title': 'Settings'},
  ];
  void addRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AddCredentials.routeName);
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
      appBar: (_selectedPageIndex == 0)
          ? AppBar(
              //leading: const Icon(Icons.menu),
              title: Text(_pages[_selectedPageIndex]['title'] as String),
              actions: [
                IconButton(
                  onPressed: () => _refreshAccounts(context),
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
            )
          : null, //AppBar(
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
                Icons.star,
                color: Colors.yellow,
              ),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.circle_outlined,
              ),
              title: const Text('Other Page For Now'),
              onTap: () {
                Navigator.pop(context);
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
