import 'dart:convert';

import 'package:model/model.dart';

Array<double> arrayDoubleFromJson(String json) {
  final data = Array<double>();
  final map = jsonDecode(json) as Map;
  for (var entry in map.entries) {
    final keyParts = entry.key.split("_");
    final x = int.parse(keyParts[0]);
    final y = int.parse(keyParts[1]);
    final value = entry.value as double;
    data.put(PointInt(x, y), value);
  }

  return data;
}

String arrayDoubleToJson(Array<double> data) {
  final map = Map<String, dynamic>.fromEntries(
    data.entries.map(
      (e) => MapEntry(
        "${e.position.x}_${e.position.y}",
        e.value,
      ),
    ),
  );

  return jsonEncode(map);
}
