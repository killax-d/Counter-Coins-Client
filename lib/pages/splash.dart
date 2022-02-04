import 'package:flutter/material.dart';
import 'package:flutter_application_projet/models/setting.dart';
import 'package:flutter_application_projet/services/auth.dart';
import 'package:flutter_application_projet/services/database.dart';
import 'package:flutter_application_projet/services/storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({ Key? key }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _addCallback();
  }

  Future<void> _addCallback() async {
    await DatabaseService().database;
    await StorageService().init();
    await Settings.init();
    WidgetsBinding.instance!.addPostFrameCallback((_) => {
      // Push replacement the route '/login if user is not logged in
      if (_auth.user == null) {
        Navigator.pushReplacementNamed(context, '/login')
      } else {
        Navigator.pushReplacementNamed(context, '/home')
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor
        )
      ),
    );
  }
}