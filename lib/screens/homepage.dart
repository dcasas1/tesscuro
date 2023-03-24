import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/account_item.dart';
import './addcredentials.dart';
import '../providers/credentials.dart';
import './editsettings.dart';

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

  void editRoute(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(EditSettings.routeName);
  }

  Future<void> _refreshAccounts(BuildContext context) async {
    await Provider.of<Credentials>(context, listen: false).fetchAccounts();
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
      //Waits for accounts to be grabbed from backend before loading
      body: _isLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : listLength > 0
              ? RefreshIndicator(
                  onRefresh: () => _refreshAccounts(context),
                  child: LayoutBuilder(
                    builder: (
                      context,
                      constraints,
                    ) {
                      return Column(
                        children: <Widget>[
                          //Passes the data into individual cards
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(10.0),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              itemCount: accounts.length,
                              itemBuilder: ((context, index) => InkWell(
                                  onTap: () => editRoute(context),
                                  child: ChangeNotifierProvider.value(
                                    value: accounts[index],
                                    key: ValueKey(accounts),
                                    child: const AccountView(),
                                  ))),
                            ),
                          ),
                          //Text below the list view
                          Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            child: Text(
                              'Tap \'+\' to add another account!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  //Button to add account if no accounts are in db
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
