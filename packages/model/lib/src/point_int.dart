import 'dart:math' as math;

import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'point_int.g.dart';

@JsonSerializable(explicitToJson: true)
class PointInt {
  int x;
  int y;

  PointInt(this.x, this.y);

  PointDouble toDouble() => PointDouble(x.toDouble(), y.toDouble());

  double distanceTo(PointInt other) {
    final a = math.Point<int>(x, y);
    final b = math.Point<int>(other.x, other.y);
    return a.distanceTo(b);
  }

  int squaredDistanceTo(PointInt other) {
    final a = math.Point<int>(x, y);
    final b = math.Point<int>(other.x, other.y);
    return a.squaredDistanceTo(b);
  }

  PointInt operator +(PointInt other) {
    return PointInt(x + other.x, y + other.y);
  }

  PointInt operator -(PointInt other) {
    return PointInt(x - other.x, y - other.y);
  }

  PointInt operator *(int other) {
    return PointInt(x * other, y * other);
  }

  PointInt operator /(int other) {
    return PointInt((x / other).floor(), (y / other).floor());
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PointInt && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => "($x,$y)";

  factory PointInt.fromJson(Map<String, dynamic> json) => _$PointIntFromJson(json);

  Map<String, dynamic> toJson() => _$PointIntToJson(this);
}
