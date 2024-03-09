import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

import 'converter/array_bool.dart';

part 'planet_satellite.g.dart';

@JsonSerializable(explicitToJson: true)
class PlanetSatellite with EquatableMixin {
  final String uid;
  final double revolutionsPerSecond;
  final double radius;
  PointDouble position;
  double planetAngle;
  final OrbitData orbit;
  bool orbitVisible;
  final PlanetSatelliteTerrain terrain;

  bool consuming;

  PlanetSatellite({
    required this.uid,
    required this.position,
    required this.consuming,
    required this.radius,
    required this.planetAngle,
    required this.revolutionsPerSecond,
    required this.orbit,
    required this.terrain,
    this.orbitVisible = false,
  });

  factory PlanetSatellite.fromJson(Map<String, dynamic> json) => _$PlanetSatelliteFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetSatelliteToJson(this);

  @override
  List<Object?> get props => [
        uid,
        position,
        consuming,
        radius,
        planetAngle,
        revolutionsPerSecond,
        orbit,
        orbitVisible,
        terrain,
      ];
}
