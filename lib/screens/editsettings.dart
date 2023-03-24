import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './nav_bar.dart';
import '../providers/credentials.dart';
import '../providers/user_credentials_struct.dart';

class EditSettings extends StatefulWidget {
  const EditSettings({super.key});
  static const routeName = '/edit-settings';

  @override
  State<EditSettings> createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  final _form = GlobalKey<FormState>();

  void homeRoute(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(NavBar.routeName);
  }

  final _urlFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  //final _confirmPassFocusNode = FocusNode();

  var _editedAccount = Accounts(
    id: '',
    siteName: '',
    siteUrl: '',
    userName: '',
    password: '',
  );

  var _initValues = {
    'siteName': '',
    'siteUrl': '',
    'userName': '',
    'password': '',
  };

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    //_confirmPassFocusNode.dispose();
    super.dispose();
  }

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final accountId = ModalRoute.of(context)!.settings.arguments as String;
        print(accountId);
        if (accountId.isNotEmpty) {
          final account = Provider.of<Credentials>(context).findById(accountId);
          _editedAccount = account;
          _initValues = {
            'siteName': _editedAccount.siteName,
            'siteUrl': _editedAccount.siteUrl,
            'userName': _editedAccount.userName,
            'password': _editedAccount.password,
          };
        }
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    if (_editedAccount.id != null) {
      await Provider.of<Credentials>(context, listen: false)
          .updateProduct(_editedAccount.id, _editedAccount);
    } else {
      try {
        await Provider.of<Credentials>(context, listen: false)
            .addAccount(_editedAccount);
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx, rootNavigator: true).pop('dialog');
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Settings')),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['siteName'],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of Site',
                  hintText: 'Site Name',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_urlFocusNode);
                },
                onSaved: (value) {
                  _editedAccount = Accounts(
                      id: _editedAccount.id,
                      siteName: value!,
                      siteUrl: _editedAccount.siteUrl,
                      password: _editedAccount.password,
                      userName: _editedAccount.userName);
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              TextFormField(
                initialValue: _initValues['siteUrl'],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL',
                  hintText: 'Enter URL',
                ),
                textInputAction: TextInputAction.next,
                focusNode: _urlFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_usernameFocusNode);
                },
                onSaved: (value) {
                  _editedAccount = Accounts(
                      id: _editedAccount.id,
                      siteName: _editedAccount.siteName,
                      siteUrl: value!,
                      password: _editedAccount.password,
                      userName: _editedAccount.userName);
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              TextFormField(
                initialValue: _initValues['userName'],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter Username',
                ),
                textInputAction: TextInputAction.next,
                focusNode: _usernameFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onSaved: (value) {
                  _editedAccount = Accounts(
                      id: _editedAccount.id,
                      siteName: _editedAccount.siteName,
                      siteUrl: _editedAccount.siteUrl,
                      password: _editedAccount.password,
                      userName: value!);
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              TextFormField(
                initialValue: _initValues['password'],
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password for Site',
                  hintText: 'Enter Password for Site',
                ),
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  // FocusScope.of(context)
                  //     .requestFocus(_confirmPassFocusNode);
                  _saveForm();
                },
                onSaved: (value) {
                  _editedAccount = Accounts(
                      id: _editedAccount.id,
                      siteName: _editedAccount.siteName,
                      siteUrl: _editedAccount.siteUrl,
                      password: value!,
                      userName: _editedAccount.userName);
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              // TextFormField(
              //   obscureText: true,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Confirm Password',
              //     hintText: 'Confirm Password for Site',
              //   ),
              //   textInputAction: TextInputAction.done,
              //   focusNode: _confirmPassFocusNode,
              //   onSaved: (value) {
              //     _editedAccount = Accounts(
              //         id: value!,
              //         siteName: _editedAccount.siteName,
              //         siteUrl: _editedAccount.siteUrl,
              //         password: _editedAccount.password,
              //         userName: _editedAccount.userName);
              //   },
              //   onFieldSubmitted: (_) {
              //     _saveForm();
              //   },
              // ),
              Container(
                padding: const EdgeInsets.all(20),
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    _saveForm();
                  },
                  child: const Text(
                    'Submit',
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
