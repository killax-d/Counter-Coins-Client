import 'dart:convert';

import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_application_projet/providers/model.dart';
import 'package:flutter_application_projet/providers/provider.dart';
import 'package:flutter_application_projet/providers/zone.dart';
import 'package:flutter_application_projet/services/database.dart';
import 'package:sqflite/sqflite.dart';

/// Example of data received from the API
/// {
///  "id": "86052620-02d1-49c3-a318-91c57d9f934c",
///  "status": "done",
///  "datetime": "2021-12-02T19:17:19.282281+01:00",
///  "calculated": 401,
///  "score": 95.4418587187926,
///  "model": "86052620-02d1-49c3-a318-91c57d9f934c",
///  "zones": [ ... ]
/// }

class ReportProvider implements Provider<Report> {
  
  final String tableName = "report";

  @override
  String get createTableSQL => 
    "CREATE TABLE IF NOT EXISTS $tableName ("
      "_id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "id TEXT,"
      "status TEXT,"
      "datetime TEXT,"
      "calculated INTEGER,"
      "score REAL,"
      "model TEXT,"
      "image BLOB,"
      "image_debug BLOB"
    ")"
  ;

  @override
  String get deleteTableSQL => 
    "DROP TABLE IF EXISTS $tableName"
  ;

  @override
  Future<void> insert(Map<String, dynamic> data) async {
    Database db = await DatabaseService().database;
    if (data.keys.contains("zones") && data.keys.contains("status") && data.keys.contains("datetime") && data.keys.contains("calculated") && data.keys.contains("score")) {
      dynamic zones = data["zones"];
      data.remove("zones");
      db.insert(tableName, data);
      for (var zone in zones) {
        zone["report_id"] = data["id"];
        await ZoneProvider().insert(zone);
      }
    } else {
      throw Exception("Missing data");
    }
  }

  @override
  Future<void> delete(Map<String, dynamic> where) async {
    Database db = await DatabaseService().database;
    await db.delete(tableName, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
    await ZoneProvider().delete({"report_id": where["id"]});
  }

  @override
  Future<void> update(Map<String, dynamic> data, Map<String, dynamic> where) async {
    Database db = await DatabaseService().database;
    if (data.keys.contains("zones") && data.keys.contains("calculated") && data.keys.contains("score")) {
      dynamic zones = data["zones"];
      data.remove("zones");
      db.update(tableName, data, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
      for (var zone in zones) {
        await ZoneProvider().update(zone, {"report_id": zone["id"], "id": zone["id"]});
      }
    } else {
      throw Exception("Missing data");
    }
  }

  @override
  Future<List<Report>> getAll() async {
    Database db = await DatabaseService().database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Report> reports = [];
    for (var map in maps) {
      Report report = Report.fromJson(map);
      report.zones = await ZoneProvider().get({"report_id": map["id"]});
      reports.add(report);
    }
    return reports;
  }

  @override
  Future<List<Report>> get(Map<String, dynamic> where, [int? limit]) async {
    Database db = await DatabaseService().database;
    List<Map<String, dynamic>> maps = await db.query(tableName, limit: limit, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
    List<Report> reports = [];
    for (var map in maps) {
      Report report = Report.fromJson(map);
      report.zones = await ZoneProvider().get({"report_id": map["id"]});
      reports.add(report);
    }
    return reports;
  }

  @override
  Future<Report?> getFirst(Map<String, dynamic> where, [int? limit]) async {
    return get(where, 1).then((List<Report> reports) {
      if (reports.isNotEmpty) {
        return reports[0];
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> wipe() async {
    Database db = await DatabaseService().database;
    await db.execute(deleteTableSQL);
    await ZoneProvider().wipe();
    // Recreate tables
    await db.execute(createTableSQL);
  }

}