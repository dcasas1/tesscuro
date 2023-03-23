import 'package:flutter/material.dart';
import './homepage.dart';
import './editsettings.dart';
import './addcredentials.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_selectedPageIndex == 0)
          ? AppBar(
              leading: const Icon(Icons.menu),
              title: Text(_pages[_selectedPageIndex]['title'] as String),
              actions: [
                const Icon(
                  Icons.refresh,
                  size: 31,
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
          : AppBar(
              leading: const Icon(Icons.menu),
              title: Text(_pages[_selectedPageIndex]['title'] as String),
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
