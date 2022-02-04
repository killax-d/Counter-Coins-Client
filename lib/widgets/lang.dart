import 'package:flutter_application_projet/helpers/langs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_projet/main.dart';

class LangDropdown extends StatefulWidget {
  const LangDropdown({ Key? key }) : super(key: key);

  @override
  _LangDropdownState createState() => _LangDropdownState();
}

class _LangDropdownState extends State<LangDropdown> {

  Lang? selected;

  @override
  void initState() {
    super.initState();
    selected = LangsHelper.getLang(App.getLocale(context));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Lang>(
      icon: const Icon(Icons.language),
      items: LangsHelper.supportedLangs.map((lang) => 
        DropdownMenuItem(value: lang,
            child: Text(lang.label),
          ),
        ).toList(),
      onChanged: (Lang? lang) {
        App.setLocale(context, lang!.locale);
        setState(() {
          selected = LangsHelper.getLang(App.getLocale(context));
        });
      },
      value: selected,
    );
  }

}