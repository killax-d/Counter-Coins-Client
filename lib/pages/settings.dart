import 'package:flutter/material.dart';
import 'package:flutter_application_projet/widgets/drawer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      drawer: const NavigationDrawer(),
      body: ListView(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(top: 10, bottom: 4), child: Center(child: Text('Applications', style: Theme.of(context).textTheme.headline6))),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.general),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/settings/general');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context)!.account, style: const TextStyle(decoration: TextDecoration.lineThrough)),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/settings/account');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(AppLocalizations.of(context)!.notifications, style: const TextStyle(decoration: TextDecoration.lineThrough)),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/settings/notifications');
            },
          ),
          const SizedBox(height: 20),
          Padding(padding: const EdgeInsets.only(top: 10, bottom: 4), child: Center(child: Text('Security', style: Theme.of(context).textTheme.headline6))),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(AppLocalizations.of(context)!.privacy, style: const TextStyle(decoration: TextDecoration.lineThrough)),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/settings/privacy');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(AppLocalizations.of(context)!.terms, style: const TextStyle(decoration: TextDecoration.lineThrough)),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/settings/terms');
            },
          ),
          const SizedBox(height: 20),
          Padding(padding: const EdgeInsets.only(top: 10, bottom: 4), child: Center(child: Text('Connectivity', style: Theme.of(context).textTheme.headline6))),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.api),
            title: Text(AppLocalizations.of(context)!.api),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/settings/api');
            },
          ),
        ],
      ),
    );
  }
}