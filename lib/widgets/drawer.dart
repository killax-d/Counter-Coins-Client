import 'package:flutter/material.dart';
import 'package:flutter_application_projet/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Image.network("https://picsum.photos/600/300", fit: BoxFit.fill),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.home, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.history, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.settings, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.help, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/help');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.about, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.white)),
              onTap: () {
                _auth.signOut().then((value) =>
                    Navigator.pushReplacementNamed(context, '/login'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
