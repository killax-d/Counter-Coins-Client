import 'package:flutter/material.dart';
import 'package:flutter_application_projet/widgets/lang.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsGeneralPage extends StatefulWidget {
  const SettingsGeneralPage({ Key? key }) : super(key: key);

  @override
  _SettingsGeneralPageState createState() => _SettingsGeneralPageState();
}

class _SettingsGeneralPageState extends State<SettingsGeneralPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.generalSettings),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.language, style: Theme.of(context).textTheme.headline6),
                const LangDropdown(),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}