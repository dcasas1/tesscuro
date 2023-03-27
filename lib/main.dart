import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/credentials.dart';
import './screens/createaccount.dart';
import './screens/homepage.dart';
import './screens/login.dart';
import './screens/addcredentials.dart';
import './screens/editsettings.dart';
import './screens/nav_bar.dart';
import './screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((ctx) => Credentials()),
        ),
      ],
      child: MaterialApp(
        title: 'Tesscuro',
        theme: ThemeData(
            canvasColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith(
              secondary: Colors.red,
            )),
        //home: const LoginPage(title: 'Login Page'),
        routes: {
          '/': (ctx) => const LoginPage(),
          HomePage.routeName: (ctx) => const HomePage(),
          CreateAccount.routeName: (ctx) => const CreateAccount(),
          LoginPage.routeName: (ctx) => const LoginPage(),
          AddCredentials.routeName: (ctx) => const AddCredentials(),
          EditSettings.routeName: (ctx) => const EditSettings(),
          NavBar.routeName: (ctx) => const NavBar(),
          Settings.routeName: (ctx) => const Settings(),
        },
      ),
    );
  }
}
