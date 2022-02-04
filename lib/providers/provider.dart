abstract class Provider<T> {

  String get createTableSQL;

  String get deleteTableSQL;

  Future<void> insert(Map<String, dynamic> data);

  Future<void> delete(Map<String, dynamic> where);

  Future<void> update(Map<String, dynamic> data, Map<String, dynamic> where);

  Future<List<T>> getAll();

  Future<List<T>> get(Map<String, dynamic> where, [int? limit]);

  Future<T?> getFirst(Map<String, dynamic> where);

  Future<void> wipe();

}