import 'package:model/model.dart';

class Array<T> {
  Map<int, Map<int, T>> map;

  int _version = 0;

  int get version => _version;

  Array() : map = {};

  void put(PointInt position, T value) {
    final row = map[position.y] ?? <int, T>{};
    row[position.x] = value;
    map[position.y] = row;
    _version += 1;
  }

  void putByIndex(int x, int y, T value) {
    final row = map[y] ?? <int, T>{};
    row[x] = value;
    map[y] = row;
    _version += 1;
  }

  void remove(PointInt position) {
    final row = map[position.y];
    if (row != null) {
      if (row.containsKey(position.x)) {
        row.remove(position.x);
        _version += 1;
      }
    }
  }

  void replace(Array<T> newData) {
    map = newData.map;
    _version += 1;
  }

  clear() {
    map.clear();
    _version += 1;
  }

  void bumpVersion() {
    _version += 1;
  }

  T? get(PointInt position) {
    final row = map[position.y];
    if (row != null) {
      return row[position.x];
    }

    return null;
  }

  T? getByIndex(int x, int y) {
    final row = map[y];
    if (row != null) {
      return row[x];
    }

    return null;
  }

  List<ArrayEntryModel<T>> get entries {
    final result = <ArrayEntryModel<T>>[];

    for (var elementY in map.entries) {
      for (var elementX in elementY.value.entries) {
        result.add(
          ArrayEntryModel(
            position: PointInt(elementX.key, elementY.key),
            value: elementX.value,
          ),
        );
      }
    }

    return result;
  }
}

class ArrayEntryModel<T> {
  final PointInt position;
  final T value;

  ArrayEntryModel({
    required this.position,
    required this.value,
  });
}
