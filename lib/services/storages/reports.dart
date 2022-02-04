import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_application_projet/providers/report.dart';
import 'package:flutter_application_projet/services/storage.dart';

class ReportStorage implements Storage<Report> {

  final List<Report> storage = [];

  @override
  Future<void> init() async {
    storage.addAll(await ReportProvider().getAll());
  }

  @override
  Future<List<Report>> set(List<Report> content) async {
    await clear();
    for (Report report in content) {
      add(report);
    }
    return content;
  }

  @override
  Future<Report> add(Report content) async {
    await ReportProvider().insert(content.toJson());
    storage.add(content);
    return content;
  }

  @override
  Future<List<Report>> addAll(List<Report> content) async {
    for (Report report in content) {
      add(report);
    }
    return content;
  }

  @override
  Future<List<Report>> getAll() async {
    return storage;
  }
  
  @override
  Future<Report> remove(Report content) async {
    storage.removeWhere((Report report) => report.id == content.id);
    await ReportProvider().delete({"id": content.id});
    return content;
  }

  @override
  Future<void> clear() async {
    // Need to wipe all database
    await ReportProvider().wipe();
    storage.clear();
  }

}