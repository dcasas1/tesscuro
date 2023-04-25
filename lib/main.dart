import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import './firebase_options.dart';
import './screens/favorites.dart';
import './screens/create_user.dart';
import './screens/homepage.dart';
import './screens/login.dart';
import './screens/addcredentials.dart';
import './screens/editsettings.dart';
import './screens/nav_bar.dart';
import './screens/settings.dart';
import './screens/generator.dart';
import './screens/password_reset.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instanceFor(app: app);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer? _backTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_backTimer != null) {
        _backTimer!.cancel();
      }
      _backTimer = Timer(const Duration(minutes: 15), () {
        FirebaseAuth.instance.signOut();
      });
    }
    if (state == AppLifecycleState.resumed) {
      if (_backTimer != null) {
        _backTimer!.cancel();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.red,
        ),
      ),
      dark: ThemeData.dark(),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tesscuro',
        theme: theme,
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
          PasswordReset.routeName: (ctx) => const PasswordReset(),
          Favorites.routeName: (ctx) => const Favorites(),
        },
      ),
    );
  }
}
