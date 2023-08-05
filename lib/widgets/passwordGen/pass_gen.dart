import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:flutter/services.dart';

class GenPass extends StatefulWidget {
  static const routeName = '/generate-password';

  const GenPass({super.key});

  @override
  State<GenPass> createState() => _GenPassState();
}

class _GenPassState extends State<GenPass> {
  bool _isWithLetters = true;
  bool _isWithUppercase = false;
  bool _isWithNumbers = false;
  bool _isWithSpecial = false;
  bool _isVisible = false;
  double _numberCharPassword = 8;
  String newPassword = '';
  Color _color = Colors.blue;
  String isOk = '';
  final TextEditingController _passwordLength = TextEditingController();
  final password = RandomPasswordGenerator();
  @override
  void initState() {
    super.initState();
  }

  checkBox(String name, Function onTap, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(name),
        Checkbox(
          activeColor: Colors.blue,
          value: value,
          onChanged: (value) {
            onTap(value);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                checkBox('Upper Case', (bool value) {
                  _isWithUppercase = value;
                  setState(() {});
                }, _isWithUppercase),
                checkBox('Lower Case', (bool value) {
                  _isWithLetters = value;
                  setState(() {});
                }, _isWithLetters)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                checkBox('Symbols', (bool value) {
                  _isWithSpecial = value;
                  setState(() {});
                }, _isWithSpecial),
                checkBox('Numbers', (bool value) {
                  _isWithNumbers = value;
                  setState(() {});
                }, _isWithNumbers)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _passwordLength,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(25.0),
                      //borderSide: BorderSide(),
                      ),
                  //filled: true,
                  //fillColor: Colors.grey[300],
                  labelText: '(Optional) Password Length (Max 100)',
                  hintText: 'Enter Length',
                  //labelStyle: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Transform.scale(
              scale: 1.3,
              child: FloatingActionButton.large(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    _isVisible = true;
                    if (_passwordLength.text.trim().isNotEmpty) {
                      _numberCharPassword =
                          double.parse(_passwordLength.text.trim());
                    }
                    if (_numberCharPassword > 100) {
                      newPassword = '';
                      isOk = 'Requested Length is too long';
                    } else {
                      newPassword = password.randomPassword(
                          letters: _isWithLetters,
                          numbers: _isWithNumbers,
                          passwordLength: _numberCharPassword,
                          specialChar: _isWithSpecial,
                          uppercase: _isWithUppercase);

                      double passwordstrength =
                          password.checkPassword(password: newPassword);
                      if (passwordstrength < 0.3) {
                        _color = Colors.red;
                        isOk = 'This password is weak!';
                      } else if (passwordstrength < 0.7) {
                        _color = Colors.blue;
                        isOk = 'This password is Good';
                      } else {
                        _color = Colors.green;
                        isOk = 'This passsword is Strong';
                      }
                    }
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Generate',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            if (newPassword.isNotEmpty)
              Center(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isOk,
                    style: TextStyle(color: _color, fontSize: 25),
                  ),
                ),
              )),
            if (newPassword.isNotEmpty)
              Center(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    newPassword,
                    style: TextStyle(color: _color, fontSize: 25),
                  ),
                ),
              )),
            if (newPassword.isEmpty)
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isOk,
                      style: TextStyle(color: _color, fontSize: 25),
                    ),
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.all(15),
            ),
            Visibility(
              visible: _isVisible,
              child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(180, 50),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: newPassword));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Password Copied!'),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Copy Password',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
            )
          ],
        ),
      ),
    );
  }
}
