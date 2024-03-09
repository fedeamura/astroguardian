abstract class DataService {
  Future<void> init();

  Future<T?> getByUid<T>({
    required String collection,
    required String uid,
    required Future<T?> Function(dynamic data) parser,
  });

  Future<int> getLength(String collection);

  Future<List<T>> getAll<T>(
    String collection, {
    required Future<T?> Function(dynamic data) parser,
  });

  Future<void> save({
    required String collection,
    required String uid,
    required Future<Map<String, dynamic>> Function() provider,
  });

  Future<void> delete({
    required String collection,
    required String uid,
  });

  Future<void> deleteAll(String collection);
}
