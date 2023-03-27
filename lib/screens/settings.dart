import 'package:flutter/material.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static const routeName = '/settings';

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool light = true;
  // bool _darkModeEnabled = false;

  // void _checkIfDarkModeEnabled() {
  //   final ThemeData theme = Theme.of(context);
  //   theme.brightness == ThemeData().brightness
  //       ? _darkModeEnabled = true
  //       : _darkModeEnabled = false;
  // }

  // bool dark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            if (light == false)
              Text("Dark Mode Disabled")
            else
              Text("Dark Mode Enabled"),
            Switch(
              value: light,
              onChanged: (value) {
                setState(() {
                  light = value;
                  if (light) {
                    print("Dark Mode");
                    MyApp.of(context)?.changeTheme(ThemeMode.dark);
                  } else {
                    print("Light Mode");
                    MyApp.of(context)?.changeTheme(ThemeMode.light);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
