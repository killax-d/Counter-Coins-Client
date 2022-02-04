import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_application_projet/models/model.dart';
import 'package:flutter_application_projet/models/zone.dart';
import 'package:flutter/material.dart';

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

class Report {
  String id;
  String status;
  DateTime datetime;
  int calculated;
  double score;
  List<ReportZone> zones;
  String model;

  Uint8List? imageBytes;
  Uint8List? imageDebugBytes;

  Report(this.id, this.status, this.datetime, this.calculated, this.score, this.zones, this.model, [this.imageBytes, this.imageDebugBytes]);

  factory Report.fromJson(Map<String, dynamic> json) {
    // If zones are not empty and not null, apply the report id transformation
    if (json['zones'] != null) {
      for (var zone in json['zones']) {
        zone['report_id'] = json['id'];
      }
    }
    return Report(
      json['id'],
      json['status'],
      DateTime.parse(json['datetime']),
      json['calculated'],
      json['score'],
      json['zones'] != null ? json['zones'].map<ReportZone>((zone) => ReportZone.fromJson(zone)).toList() : [],
      json['model'],
      json['image'] != null ? Uint8List.fromList(json['image']) : null,
      json['image_debug'] != null ? Uint8List.fromList(json['image_debug']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'calculated': calculated,
      'score': score,
      'zones': zones.map<Map<String, dynamic>>((zone) => zone.toJson()).toList(),
      'model': model,
      'image': imageBytes,
      'image_debug': imageDebugBytes,
    };
  }

  Widget get ratingWidget {
    double rating = score/20;

    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (rating > 0.5) {
        stars.add(const Icon(Icons.star, color: Colors.yellow));
      } else if (rating > 0) {
        stars.add(const Icon(Icons.star_half, color: Colors.yellow));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.yellow));
      }
      rating--;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  void updateZone(ReportZone edited) {
    zones.firstWhere((zone) => zone.id == edited.id).setCoin(edited.coin!);

    calculated = zones.fold(0, (sum, zone) => sum + zone.coin!.value);
    score = zones.fold(0.0, (sum, zone) => sum + zone.confidence);
    score /= zones.length;
  }

  bool get done {
    return status == 'done';
  }

  bool get success {
    return done && zones.isNotEmpty;
  }

  bool get failed {
    return done && zones.isEmpty;
  }
  
  bool get pending {
    return status == 'pending';
  }

  @override
  String toString() {
    return 'Report{id: $id, datetime: $datetime, calculated: $calculated, status: $status, zones: $zones}';
  }

}