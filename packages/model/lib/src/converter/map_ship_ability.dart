import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:model/model.dart';

Map<ShipAbility, StepParameter> mapShipAbilityFromJson(String json) {
  final result = <ShipAbility, StepParameter>{};
  final entries = jsonDecode(json) as List;
  for (var entry in entries) {
    final abilityValue = entry["ability_value"] as int;
    final ability = ShipAbility.values.firstWhereOrNull((e) => e.value == abilityValue);
    if (ability != null) {
      final step = StepParameter.fromJson(entry["step"] as Map<String, dynamic>);
      result[ability] = step;
    }
  }

  return result;
}

String mapShipAbilityToJson(Map<ShipAbility, StepParameter> data) {
  return jsonEncode(
    data.entries
        .map(
          (e) => {
            "ability_value": e.key.value,
            "step": e.value.toJson(),
          },
        )
        .toList(),
  );
}
