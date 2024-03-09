// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_satellite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanetSatellite _$PlanetSatelliteFromJson(Map<String, dynamic> json) =>
    PlanetSatellite(
      uid: json['uid'] as String,
      position: PointDouble.fromJson(json['position'] as Map<String, dynamic>),
      consuming: json['consuming'] as bool,
      radius: (json['radius'] as num).toDouble(),
      planetAngle: (json['planetAngle'] as num).toDouble(),
      revolutionsPerSecond: (json['revolutionsPerSecond'] as num).toDouble(),
      orbit: OrbitData.fromJson(json['orbit'] as Map<String, dynamic>),
      terrain: PlanetSatelliteTerrain.fromJson(
          json['terrain'] as Map<String, dynamic>),
      orbitVisible: json['orbitVisible'] as bool? ?? false,
    );

Map<String, dynamic> _$PlanetSatelliteToJson(PlanetSatellite instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'revolutionsPerSecond': instance.revolutionsPerSecond,
      'radius': instance.radius,
      'position': instance.position.toJson(),
      'planetAngle': instance.planetAngle,
      'orbit': instance.orbit.toJson(),
      'orbitVisible': instance.orbitVisible,
      'terrain': instance.terrain.toJson(),
      'consuming': instance.consuming,
    };
