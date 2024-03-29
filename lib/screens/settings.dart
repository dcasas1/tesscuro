import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import './generator.dart';
import './create_user.dart';

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
        ? _darkModeEnabled = false
        : _darkModeEnabled = true;
    return _darkModeEnabled;
  }

  @override
  Widget build(BuildContext context) {
    bool response = _checkIfDarkModeEnabled();
    bool check = response;
    return Scaffold(
      body: (response == false)
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 75),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (check == false)
                          const Text(
                            "Dark Mode Disabled",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        if (check == true) const Text("Dark Mode Enabled"),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: check,
                            onChanged: (value) {
                              setState(() {
                                check = value;
                                if (light == true) {
                                  AdaptiveTheme.of(context).setDark();
                                }
                                if (light == false) {
                                  AdaptiveTheme.of(context).setLight();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 10),
                      onPressed: () => generateRoute(context),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Generate Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 75),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (check == false) const Text("Dark Mode Disabled"),
                        if (check == true)
                          const Text(
                            "Dark Mode Enabled",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: check,
                            onChanged: (value) {
                              setState(() {
                                check = value;
                                if (light == false) {
                                  AdaptiveTheme.of(context).setDark();
                                }
                                if (light == true) {
                                  AdaptiveTheme.of(context).setLight();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 10),
                      onPressed: () => generateRoute(context),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Generate Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
