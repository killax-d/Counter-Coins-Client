import 'package:flutter/material.dart';
import 'package:flutter_application_projet/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_application_projet/widgets/lang.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  String? _email;
  String? _password;
  String? _passwordConfirm;
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  bool _hasAccount = true;

  bool _passwordVisible = false;
  String? _message;

  Widget emailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.email,
        hintText: AppLocalizations.of(context)!.email,
        icon: const Icon(Icons.mail),
      ),
      keyboardType: TextInputType.emailAddress
    );
  }

  Widget passwordInput(String labelText, TextEditingController controller) {
    return TextFormField(
      obscureText: !_passwordVisible,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: labelText,
        icon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      )
    );
  }


  void submit() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    _passwordConfirm = _passwordConfirmController.text;
    _message = '';
    try {
      dynamic result;
      if (_hasAccount) {
        result = await _auth.signInWithEmailAndPassword(_email!, _password!);
      } else {
        if (_password == _passwordConfirm) { result = await _auth.registerWithEmailAndPassword(_email!, _password!); }
        else {
          setState(() {
            _message = AppLocalizations.of(context)!.passwordNotEqual;
          });
        }
      }
      if (_auth.user != null) {
        Navigator.pushReplacementNamed(
          context, 
          _hasAccount ? '/home' : '/help'
        );
      } else {
        setState(() {
          _message = _auth.getError(result, context);
        });
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_hasAccount ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.register),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const LangDropdown(),
                Text(_message ?? '', style: const TextStyle(color: Colors.red)),
                emailInput(),
                const SizedBox(height: 8),
                passwordInput(AppLocalizations.of(context)!.password, _passwordController),
                const SizedBox(height: 8),
                _hasAccount ? Container() : passwordInput(AppLocalizations.of(context)!.passwordConfirm, _passwordConfirmController),
              ]
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(3),
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(_hasAccount ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.register),
                  onPressed: () {
                    submit();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                  ),
                  child: Text(_hasAccount ? AppLocalizations.of(context)!.createAccount : AppLocalizations.of(context)!.alreadyRegistered),
                  onPressed: () {
                    setState(() {
                      _hasAccount = !_hasAccount;
                      _message = '';
                    });
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
