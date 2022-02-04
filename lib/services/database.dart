import 'dart:io';

import 'package:flutter_application_projet/providers/model.dart';
import 'package:flutter_application_projet/providers/provider.dart';
import 'package:flutter_application_projet/providers/report.dart';
import 'package:flutter_application_projet/providers/zone.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  // Add providers to initializations
  List<Provider> providers = [ReportProvider(), ModelProvider(), ZoneProvider()];

  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        for (Provider provider in providers) {
          db.execute(provider.createTableSQL);
        }
      },
      version: 1,
    );
  }

}