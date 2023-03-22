import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesscuro/widgets/account_grids.dart';
import './addcredentials.dart';
import '../providers/credentials.dart';

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

  var _isInit = true;
  var _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoaded = true;
      });
      Provider.of<Credentials>(context)
          .fetchAccounts()
          .then((_) => _isLoaded = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const AccountsGrid(),

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
