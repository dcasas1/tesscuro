import 'package:flutter/material.dart';
import 'package:tesscuro/screens/generator.dart';
import 'package:tesscuro/screens/login.dart';
import '../main.dart';
import './createaccount.dart';
import './generator.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static const routeName = '/settings';

  @override
  State<Settings> createState() => _SettingsState();
}

//generate password route
void generateRoute(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(GeneratePassword.routeName);
}

void createRoute(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(CreateAccount.routeName);
}

class _SettingsState extends State<Settings> {
  bool light = true;
  bool _darkModeEnabled = false;

  bool _checkIfDarkModeEnabled() {
    final ThemeData theme = Theme.of(context);
    theme.brightness == ThemeData().brightness
        ? _darkModeEnabled = true
        : _darkModeEnabled = false;
    return _darkModeEnabled;
  }

  // bool dark = false;
  @override
  Widget build(BuildContext context) {
    bool response = _checkIfDarkModeEnabled();
    print(response);
    bool check = response;
    print(response);
    return Scaffold(
      body: (response == true)
          ? Container(
              child: Column(
                children: [
                  if (check == true) Text("Dark Mode Disabled"),
                  if (check == false) Text("Dark Mode Enabled"),
                  Switch(
                    value: check,
                    onChanged: (value) {
                      setState(() {
                        check = value;
                        if (light == true) {
                          print("Dark Mode");
                          MyApp.of(context)?.changeTheme(ThemeMode.dark);
                        }
                        if (light == false) {
                          print("Light Mode");
                          MyApp.of(context)?.changeTheme(ThemeMode.light);
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => generateRoute(context),
                    child: const Text(
                      'Generate Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Column(
                children: [
                  if (check == true) Text("Dark Mode Disabled"),
                  if (check == false) Text("Dark Mode Enabled"),
                  Switch(
                    value: check,
                    onChanged: (value) {
                      setState(() {
                        check = value;
                        if (light == false) {
                          print("Dark Mode");
                          MyApp.of(context)?.changeTheme(ThemeMode.dark);
                        }
                        if (light == true) {
                          print("Light Mode");
                          MyApp.of(context)?.changeTheme(ThemeMode.light);
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => generateRoute(context),
                    child: const Text(
                      'Generate Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
