import 'package:flutter/material.dart';
import 'package:flutter_application_projet/helpers/langs.dart';
import 'package:flutter_application_projet/pages/settings.dart';
import 'package:flutter_application_projet/pages/settings/general.dart';
import 'package:flutter_application_projet/pages/settings/api.dart';
import 'package:flutter_application_projet/pages/splash.dart';
import 'package:flutter_application_projet/pages/login.dart';
import 'package:flutter_application_projet/pages/home.dart';
import 'package:flutter_application_projet/pages/history.dart';
import 'package:flutter_application_projet/pages/help.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();

  static Locale getLocale(BuildContext context) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    return state!._locale;
  }

  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    state!.changeLanguage(newLocale);
  }
}

class _AppState extends State<App> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = LangsHelper.defaultLang.locale;
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Projet',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LangsHelper.supportedLangs.map((e) => e.locale),
        locale: _locale,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (locale != null &&
                supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/history': (context) => const HistoryPage(),
          '/help': (context) => const HelpPage(),
          '/settings': (context) => const SettingsPage(),
          '/settings/general': (context) => const SettingsGeneralPage(),
          '/settings/api': (context) => const SettingsApiPage(),
        });
  }
}
