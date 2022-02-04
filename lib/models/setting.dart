// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Settings {

  static const String API_DOMAIN = "settings.api.domain";
  static const String API_KEY = "settings.api.key";
  static const String API_SECURE = "settings.api.secure";

  static Map<String, dynamic> _settings = {};

  static Map<String, dynamic> defaultSettings = {
    API_DOMAIN: "api.dylan-donne.fr",
    API_KEY: "",
    API_SECURE: true,
  };

  static Future<void> init() async {
    _settings = await _loadSettings();
  }

  static Future<Map<String, dynamic>> _loadSettings() async {
    final file = await _getSettingsFile();
    if (await file.exists()) {
      try {
        _settings = json.decode(await file.readAsString());
      } catch (e) {
        _settings = defaultSettings;
      }
    } else {
      _settings = defaultSettings;
      await save();
    }
    return _settings;
  }

  static Future<File> _getSettingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/settings.json');
  }

  static Future<void> save() async {
    final file = await _getSettingsFile();
    await deleteAll();
    await file.writeAsString(json.encode(_settings), mode: FileMode.write);
  }

  static void set(String key, dynamic value) {
    _settings[key] = value;
  }

  static dynamic get(String key) {
    return _settings[key];
  }

  static void delete(String key) {
    _settings.remove(key);
  }

  static void clear() {
    _settings = defaultSettings;
  }

  static Future<void> deleteAll() async {
    final file = await _getSettingsFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }

}