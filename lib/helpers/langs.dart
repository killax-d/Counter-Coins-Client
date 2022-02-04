
import 'dart:ui';

class LangsHelper {
  static final List<Lang> supportedLangs = [
    Lang("English", const Locale('en', 'GB')),
    Lang("Français", const Locale('fr', 'FR')),
  ];

  static final Lang defaultLang = supportedLangs[0];

  static Lang getLang(Locale locale) {
    return supportedLangs.firstWhere(
      (Lang l) => 
            l.locale.languageCode == locale.languageCode 
        &&  l.locale.countryCode == locale.countryCode, 
      orElse: 
      () => 
            defaultLang);
  }
}

class Lang {
  String label;
  Locale locale;

  Lang(this.label, this.locale);
}