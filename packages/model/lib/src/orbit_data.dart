import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'orbit_data.g.dart';

@JsonSerializable(explicitToJson: true)
class OrbitData with EquatableMixin {
  double a;
  double b;
  double inclination;

  OrbitData({
    required this.a,
    required this.b,
    required this.inclination,
  });

  factory OrbitData.fromJson(Map<String, dynamic> json) => _$OrbitDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrbitDataToJson(this);

  PointDouble evaluate({
    required PointDouble center,
    required double angle,
  }) {
    double x = center.x + a * math.cos(angle) * math.cos(inclination) - b * math.sin(angle) * math.sin(inclination);
    double y = center.y + a * math.cos(angle) * math.sin(inclination) + b * math.sin(angle) * math.cos(inclination);
    return PointDouble(x, y);
  }

  double calculateAngle({
    required PointDouble center,
    required PointDouble position,
  }) {
    final x = position.x - center.x;
    final y = position.y - center.y;

    final angle = math.atan2(
      y * math.cos(inclination) - x * math.sin(inclination),
      x * math.cos(inclination) + y * math.sin(inclination),
    );

    return (angle < 0) ? angle + 2 * math.pi : angle;
  }

  double get maxSize {
    return math.max(a, b);
  }

  @override
  List<Object?> get props => [a, b, inclination];
}
