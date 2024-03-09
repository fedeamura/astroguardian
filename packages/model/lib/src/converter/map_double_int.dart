import 'dart:convert';

Map<double, int> mapDoubleIntFromJson(String json) {
  final result = <double, int>{};
  final entries = jsonDecode(json) as List;
  for (var entry in entries) {
    final key = entry["key"] as double;
    final value = entry["value"] as int;
    result[key] = value;
  }

  return result;
}

String mapDoubleIntToJson(Map<double, int> data) {
  return jsonEncode(
    data.entries.map(
      (e) => {
        "key": e.key,
        "value": e.value,
      },
    ).toList(),
  );
}
