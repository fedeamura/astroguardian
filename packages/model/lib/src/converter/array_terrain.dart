import 'dart:convert';

import 'package:model/model.dart';

Array<Terrain> arrayTerrainFromJson(String json) {
  final data = Array<Terrain>();
  final map = jsonDecode(json) as Map;
  for (var entry in map.entries) {
    final keyParts = entry.key.split("_");
    final x = int.parse(keyParts[0]);
    final y = int.parse(keyParts[1]);
    final map = entry.value as Map<String, dynamic>;
    data.put(PointInt(x, y), Terrain.fromJson(map));
  }

  return data;
}

String arrayTerrainToJson(Array<Terrain> data) {
  final map = Map<String, dynamic>.fromEntries(
    data.entries.map(
      (e) => MapEntry(
        "${e.position.x}_${e.position.y}",
        e.value.toJson(),
      ),
    ),
  );

  return jsonEncode(map);
}
