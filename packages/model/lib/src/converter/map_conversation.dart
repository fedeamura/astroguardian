import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:model/src/conversation_type.dart';

Map<ConversationType, bool> mapConversationFromJson(String json) {
  final result = <ConversationType, bool>{};
  final entries = jsonDecode(json) as List;
  for (var entry in entries) {
    final value = entry["value"] as int;
    final conversation = ConversationType.values.firstWhereOrNull((e) => e.value == value);
    if (conversation != null) {
      final completed = entry["completed"] as bool;
      result[conversation] = completed;
    }
  }

  return result;
}

String mapConversationToJson(Map<ConversationType, bool> data) {
  return jsonEncode(
    data.entries
        .map(
          (e) => {
            "value": e.key.value,
            "completed": e.value,
          },
        )
        .toList(),
  );
}
