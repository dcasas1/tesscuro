import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/account_item.dart';
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
    final accountsData = Provider.of<Credentials>(context);
    final accounts = accountsData.items;
    var listLength = accounts.length;
    return Scaffold(
      body: _isLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : listLength > 0
              ? ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  itemCount: accounts.length,
                  itemBuilder: ((context, index) =>
                      ChangeNotifierProvider.value(
                        value: accounts[index],
                        key: ValueKey(accounts),
                        child: const AccountView(),
                      )),
                )
              : Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => addRoute(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          child: const Text('Tap Here To Add An Account'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
