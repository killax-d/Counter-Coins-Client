import 'dart:async';
import 'dart:convert';

import 'package:flutter_application_projet/models/model.dart';
import 'package:flutter_application_projet/providers/provider.dart';
import 'package:flutter_application_projet/services/database.dart';
import 'package:sqflite/sqflite.dart';

/// Example of data received from the API
/// {
///  "id": "86052620-02d1-49c3-a318-91c57d9f934c",
///  "datetime": "2021-12-02T19:17:19.282281+01:00",
///  "pictures_count": { ... }
/// }

class ModelProvider implements Provider<Model> {
  
  final String tableName = "model";

  @override
  String get createTableSQL => 
    "CREATE TABLE IF NOT EXISTS $tableName ("
      "id TEXT PRIMARY KEY,"
      "datetime TEXT,"
      "pictures_count TEXT" // Stock as JSON
    ")"
  ;

  @override
  String get deleteTableSQL => 
    "DROP TABLE IF EXISTS $tableName"
  ;
  
  @override
  Future<void> insert(Map<String, dynamic> data) async {
    Database db = await DatabaseService().database;
  
    if (await getFirst({ "id": data["id"] }) != null) {
      return;
    }
    if (data.containsKey("datetime") && data.containsKey("pictures_count")) {
      if (data["pictures_count"] == null) {
        data["pictures_count"] = "{}";
      } else {
        data['pictures_count'] = json.encode(data['pictures_count']);
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
    if (data.containsKey("pictures_count")) {
      if (data["pictures_count"] == null) {
        data["pictures_count"] = "{}";
      } else {
        data['pictures_count'] = jsonEncode(data['pictures_count']);
      }
      await db.update(tableName, data, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
    } else {
      throw Exception("Missing data");
    }
  }

  @override
  Future<List<Model>> getAll() async {
    Database db = await DatabaseService().database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Model> models = [];
    for (var map in maps) {
      models.add(Model.fromJson(map));
    }
    return models;
  }

  @override
  Future<List<Model>> get(Map<String, dynamic> where, [int? limit]) async {
    Database db = await DatabaseService().database;
    List<Map<String, dynamic>> maps = await db.query(tableName, limit: limit, where: where.keys.map((k) => "$k = ?").join(" AND "), whereArgs: where.values.map((e) => e).toList());
    List<Model> models = [];
    for (var map in maps) {
      models.add(Model.fromJson(map));
    }
    return models;
  }

  @override
  Future<Model?> getFirst(Map<String, dynamic> where) async {
    return get(where, 1).then((List<Model> models) {
      if (models.isNotEmpty) {
        return models[0];
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