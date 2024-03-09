import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'point_double.g.dart';

@JsonSerializable(explicitToJson: true)
class PointDouble with EquatableMixin {
  double x;
  double y;

  PointDouble(this.x, this.y);

  PointInt toInt() => PointInt(x.floor(), y.floor());

  double distanceTo(PointDouble other) {
    final a = math.Point<double>(x, y);
    final b = math.Point<double>(other.x, other.y);
    return a.distanceTo(b);
  }

  double squaredDistanceTo(PointDouble other) {
    final a = math.Point<double>(x, y);
    final b = math.Point<double>(other.x, other.y);
    return a.squaredDistanceTo(b);
  }

  PointDouble operator +(PointDouble other) {
    return PointDouble(x + other.x, y + other.y);
  }

  PointDouble operator -(PointDouble other) {
    return PointDouble(x - other.x, y - other.y);
  }

  PointDouble operator *(int other) {
    return PointDouble(x * other, y * other);
  }

  PointDouble operator /(int other) {
    return PointDouble(x / other, y / other);
  }

  PointInt toChunk(int chunkSize) => PointInt((x / chunkSize).floor(), (y / chunkSize).floor());

  PointDouble toLocal(int chunkSize) => PointDouble(x % chunkSize, y % chunkSize);

  PointDouble toGlobal(PointInt chunkPosition, int chunkSize) {
    return (this + (chunkPosition.toDouble() * chunkSize));
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PointDouble && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => "($x,$y)";

  factory PointDouble.fromJson(Map<String, dynamic> json) => _$PointDoubleFromJson(json);

  Map<String, dynamic> toJson() => _$PointDoubleToJson(this);

  @override
  List<Object?> get props => [x, y];
}
