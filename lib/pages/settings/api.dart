import 'package:flutter/material.dart';
import 'package:flutter_application_projet/models/setting.dart';
import 'package:flutter_application_projet/services/api.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsApiPage extends StatefulWidget {
  const SettingsApiPage({ Key? key }) : super(key: key);

  @override
  _SettingsApiPageState createState() => _SettingsApiPageState();
}

class _SettingsApiPageState extends State<SettingsApiPage> {
  late String _apiDomain;
  late String _apiKey;
  late bool _secure;

  final TextEditingController _apiDomainController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiDomain = ApiService.domain;
    _apiKey = ApiService.key;
    _secure = ApiService.secure;
    _apiDomainController.text = _apiDomain;
    _apiKeyController.text = _apiKey;
  }

  Widget input(IconData icon, String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: labelText,
        icon: Icon(icon),
      )
    );
  }

  _save() async {
    ApiService.domain = _apiDomainController.text.replaceAll(" ", "");
    ApiService.key = _apiKeyController.text.replaceAll(" ", "");
    ApiService.secure = _secure;
    Settings.set(Settings.API_DOMAIN, ApiService.domain);
    Settings.set(Settings.API_KEY, ApiService.key);
    Settings.set(Settings.API_SECURE, ApiService.secure);
    await Settings.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            input(Icons.electrical_services, AppLocalizations.of(context)!.apiDomain, _apiDomainController),
            input(Icons.vpn_key, AppLocalizations.of(context)!.apiKey, _apiKeyController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.securedTraffic),
                Switch(
                  value: _secure,
                  onChanged: (value) {
                    setState(() {
                      _secure = value;
                    });
                  },
                ),
              ]
            )
          ],
        ),
      )
    );
  }
}