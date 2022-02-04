import 'package:flutter_application_projet/services/storages/reports.dart';

class StorageService {

  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  final Map<String, Storage> _storage = {
    "reports": ReportStorage(),
  };

  ReportStorage get reports => _storage['reports'] as ReportStorage;

  Future<void> init() async {
    for (Storage storage in _storage.values) {
      await storage.init();
    }
  }

  Future<dynamic> set(String key, dynamic value) async {
    _storage[key] = value;
    return value;
  }

  Future<dynamic> get(String key) async {
    return _storage[key];
  }

  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  Future<void> clear(String key) async {
    _storage.clear();
  }

  Future<void> wipe() async {
    _storage.clear();
  }

  Future<bool> contains(String key) async {
    return _storage.containsKey(key);
  }

  Future<bool> isEmpty(String key) async {
    return _storage.isEmpty;
  }

  Future<int> length(String key) async {
    return _storage.length;
  }
  
}

abstract class Storage<T> {

  Future<void> init();

  Future<List<T>> set(List<T> content);

  Future<T> add(T content);

  Future<List<T>> addAll(List<T> content);

  Future<List<T>> getAll();

  Future<T> remove(T content);

  Future<void> clear();
}