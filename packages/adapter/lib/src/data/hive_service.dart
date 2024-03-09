import 'dart:async';
import 'dart:developer';

import 'package:adapter/adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synchronized/synchronized.dart';

class HiveDataService extends DataService {
  final _lock = Lock();

  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<LazyBox> _getBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.lazyBox(name);
    }

    return Hive.openLazyBox(name);
  }

  @override
  Future<T?> getByUid<T>({
    required String collection,
    required String uid,
    required Future<T?> Function(dynamic data) parser,
  }) async {
    return _lock.synchronized(() async {
      final box = await _getBox(collection);
      final data = await box.get(uid);
      return parser(data);
    });
  }

  @override
  Future<List<T>> getAll<T>(
    String collection, {
    required Future<T?> Function(dynamic data) parser,
  }) async {
    return _lock.synchronized(() async {
      final box = await _getBox(collection);
      final keys = box.keys.toList();

      final items = <T>[];
      for (var key in keys) {
        final info = await box.get(key);
        final model = await parser(info);
        if (model != null) {
          items.add(model);
        }
      }

      return items;
    });
  }

  @override
  Future<void> save({
    required String collection,
    required String uid,
    required Future<Map<String, dynamic>> Function() provider,
  }) {
    return _lock.synchronized(() async {
      final box = await _getBox(collection);
      final data = await provider();
      await box.put(uid, data);
    });
  }

  @override
  Future<void> delete({
    required String collection,
    required String uid,
  }) {
    return _lock.synchronized(() async {
      final box = await _getBox(collection);
      await box.delete(uid);
    });
  }

  @override
  Future<void> deleteAll(String collection) {
    return _lock.synchronized(() async {
      final box = await _getBox(collection);
      await box.deleteAll(box.keys);
    });
  }

  @override
  Future<int> getLength(String collection) {
    return _lock.synchronized(() async {
      final box = await _getBox(collection);
      return box.keys.length;
    });
  }
}
