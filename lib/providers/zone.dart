import 'dart:async';
import 'dart:convert';

import 'package:flutter_application_projet/models/zone.dart';
import 'package:flutter_application_projet/providers/provider.dart';
import 'package:flutter_application_projet/services/database.dart';
import 'package:sqflite/sqflite.dart';

/// Example of data received from the API
/// {
///     "id": 0,
///     "zone": {
///       "height": 82,
///       "width": 82,
///       "x": 306,
///       "y": 442
///     },
///     "coin": "1e",
///     "old_coin": "2e", // optional
///     "confidence": 0.0,
///     "old_confidence": 99.91416931152344 // optional
///  }

class ZoneProvider implements Provider<ReportZone> {
  
  final String tableName = "zone";

  @override
  String get createTableSQL => 
    "CREATE TABLE IF NOT EXISTS $tableName ("
      "_id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "report_id TEXT," // Parent
      "id INT,"
      "zone TEXT," // Stock as JSON
      "coin TEXT,"
      "old_coin TEXT,"
      "confidence REAL,"
      "old_confidence REAL,"
      "image BLOB"
    ")"
  ;

  @override
  String get deleteTableSQL => 
    "DROP TABLE IF EXISTS $tableName"
  ;
  
  @override
  Future<void> insert(Map<String, dynamic> data) async {
    Database db = await DatabaseService().database;
    if (data.keys.contains("id") && data.keys.contains("zone") && data.keys.contains("coin") && data.keys.contains("confidence")) {
      Map<String, dynamic> zone = data["zone"];
      Map<String, dynamic> zoneData = {
        "height": zone["height"],
        "width": zone["width"],
        "x": zone["x"],
        "y": zone["y"]
      };
      data["zone"] = json.encode(zoneData);
      if (!data.keys.contains("old_coin")) {
        data["old_coin"] = "";
      }
      if (!data.keys.contains("old_confidence")) {
        data["old_confidence"] = 0.0;
      }
      await db.insert(tableName, data);
    } else {
      throw Exception("Missing data");
    }
  }  


  @override
  Future<void> delete(Map<String, dynamic> where) async {
    Database db = await DatabaseService().database;
    await db.delete(tableName, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
  }

  @override
  Future<void> update(Map<String, dynamic> data, Map<String, dynamic> where) async {
    Database db = await DatabaseService().database;
    if (data.keys.contains("id") && data.keys.contains("zone") && data.keys.contains("coin") && data.keys.contains("confidence")) {
      Map<String, dynamic> zone = data["zone"];
      Map<String, dynamic> zoneData = {
        "height": zone["height"],
        "width": zone["width"],
        "x": zone["x"],
        "y": zone["y"]
      };
      data["zone"] = json.encode(zoneData);
      if (!data.keys.contains("old_coin")) {
        data["old_coin"] = "";
      }
      if (!data.keys.contains("old_confidence")) {
        data["old_confidence"] = 0.0;
      }
      await db.update(tableName, data, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
    } else {
      throw Exception("Missing data");
    }
  }

  @override
  Future<List<ReportZone>> getAll() async {
    Database db = await DatabaseService().database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<ReportZone> zones = [];
    for (var map in maps) {
      zones.add(ReportZone.fromJson(map));
    }
    return zones;
  }

  @override
  Future<List<ReportZone>> get(Map<String, dynamic> where, [int? limit]) async {
    Database db = await DatabaseService().database;
    List<Map<String, dynamic>> maps = await db.query(tableName, limit: limit, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
    List<ReportZone> zones = [];
    for (var map in maps) {
      zones.add(ReportZone.fromJson(map));
    }
    return zones;
  }

  @override
  Future<ReportZone?> getFirst(Map<String, dynamic> where) async {
    return get(where, 1).then((List<ReportZone> zones) {
      if (zones.isNotEmpty) {
        return zones[0];
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> wipe() async {
    Database db = await DatabaseService().database;
    await db.execute(deleteTableSQL);
    // Recreate tables
    await db.execute(createTableSQL);
  }


}