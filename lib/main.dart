import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './firebase_options.dart';
import './screens/create_user.dart';
import './screens/homepage.dart';
import './screens/login.dart';
import './screens/addcredentials.dart';
import './screens/editsettings.dart';
import './screens/nav_bar.dart';
import './screens/settings.dart';
import './screens/generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instanceFor(app: app);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
  // ignore: library_private_types_in_public_api
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(
      () {
        _themeMode = themeMode;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesscuro',
      theme: ThemeData(
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.red,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return const NavBar();
          }
          return const LoginPage();
        },
      ),
      routes: {
        HomePage.routeName: (ctx) => const HomePage(),
        CreateAccount.routeName: (ctx) => const CreateAccount(),
        LoginPage.routeName: (ctx) => const LoginPage(),
        AddCredentials.routeName: (ctx) => const AddCredentials(),
        EditSettings.routeName: (ctx) => const EditSettings(),
        NavBar.routeName: (ctx) => const NavBar(),
        Settings.routeName: (ctx) => const Settings(),
        GeneratePassword.routeName: (ctx) => const GeneratePassword(),
      },
    );
  }
}
