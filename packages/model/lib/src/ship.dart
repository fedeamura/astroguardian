import 'package:json_annotation/json_annotation.dart';
import 'package:util/util.dart';
import 'package:model/model.dart';
import 'package:model/src/converter/map_ship_ability.dart';

part 'ship.g.dart';

@JsonSerializable(explicitToJson: true)
class Ship {
  final PointDouble position;
  double rotation;
  final double rotationForce;
  final double density;
  final double moveForce;
  final double stopTime;

  int _bag;

  @JsonKey(toJson: mapShipAbilityToJson, fromJson: mapShipAbilityFromJson)
  final Map<ShipAbility, StepParameter> abilities;

  double bagDistance;
  int pendingAbilityPoints;

  Ship({
    required this.position,
    required this.rotation,
    required this.rotationForce,
    required this.density,
    required this.moveForce,
    required this.stopTime,
    required this.abilities,
    required int bag,
    required this.bagDistance,
    required this.pendingAbilityPoints,
  }) : _bag = bag {
    _fix();
  }

  StepParameter get bagSize => abilities[ShipAbility.bagSize]!;

  StepParameter get raySpeed => abilities[ShipAbility.raySpeed]!;

  StepParameter get rayLength => abilities[ShipAbility.rayLength]!;

  StepParameter get rayCount => abilities[ShipAbility.rayCount]!;

  void _fix() {
    _bag = _bag.clamp(0.0, bagSize.value).floor();
  }

  // Bag capacity
  set bag(int value) {
    _bag = value;
    _fix();
  }

  int get bag => _bag;

  bool get isBagFull => _bag == bagSize.value.floor();

  double get bagPercentage => MathRangeUtil.range(
        _bag.toDouble(),
        0.0,
        bagSize.value,
        0.0,
        1.0,
      );

  factory Ship.fromJson(Map<String, dynamic> json) => _$ShipFromJson(json);

  Map<String, dynamic> toJson() => _$ShipToJson(this);
}
