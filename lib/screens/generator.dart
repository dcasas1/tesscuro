import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';

class GeneratePassword extends StatefulWidget {

  static const routeName = '/generate-password';

  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
  //const GeneratePassword({super.key});
}

class _GeneratePasswordState extends State<GeneratePassword> {
  bool _isWithLetters = true;
  bool _isWithUppercase = false;
  bool _isWithNumbers = false;
  bool _isWithSpecial = false;
  double _numberCharPassword = 8;
  String newPassword = '';
  Color _color = Colors.blue;
  String isOk = '';
  TextEditingController _passwordLength = TextEditingController();
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
        Checkbox(activeColor: Colors.blue, value: value, onChanged:(value) {
          onTap(value);
        },),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Random Password Generator'),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(
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
            SizedBox(
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _passwordLength,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    //borderRadius: BorderRadius.circular(25.0),
                    //borderSide: BorderSide(),
                  ),
                  //filled: true,
                  //fillColor: Colors.grey[300],
                  labelText: '(Optional) Password Length',
                  hintText: 'Enter Length',
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
              ),
            ),
              /*padding: EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: TextField(
                controller: _passwordLength,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '(Optional) Password Length',
                  hintText: 'Enter Length',
                ),
              ),
            ),*/
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.large(
              backgroundColor: Colors.blue,
                onPressed: () {
                  if (_passwordLength.text.trim().isNotEmpty)
                    _numberCharPassword =
                        double.parse(_passwordLength.text.trim());

                  newPassword = password.randomPassword(
                      letters: _isWithLetters,
                      numbers: _isWithNumbers,
                      passwordLength: _numberCharPassword,
                      specialChar: _isWithSpecial,
                      uppercase: _isWithUppercase);

                  print(newPassword);
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

                  setState(() {});
                },
                child: Container(
                  //color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Generate',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            if (newPassword.isNotEmpty && newPassword != null)
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
            if (newPassword.isNotEmpty && newPassword != null)
              Center(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    newPassword,
                    style: TextStyle(color: _color, fontSize: 25),
                  ),
                ),
              ))
          ],
        )),
    );
  }
}