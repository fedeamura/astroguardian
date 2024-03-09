// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Planet _$PlanetFromJson(Map<String, dynamic> json) => Planet(
      uid: json['uid'] as String,
      chunkSize: json['chunkSize'] as int,
      globalPosition:
          PointDouble.fromJson(json['globalPosition'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      terrain: PlanetTerrain.fromJson(json['terrain'] as Map<String, dynamic>),
      spinSpeed: (json['spinSpeed'] as num).toDouble(),
      satellitesCount: json['satellitesCount'] as int,
      satellites: (json['satellites'] as List<dynamic>)
          .map((e) => PlanetSatellite.fromJson(e as Map<String, dynamic>))
          .toList(),
      satelliteMaxOrbitDistance:
          (json['satelliteMaxOrbitDistance'] as num).toDouble(),
      isInitialPlanet: json['isInitialPlanet'] as bool,
      saved: json['saved'] as bool,
      satellitesVersion: json['satellitesVersion'] as int? ?? 0,
    );

Map<String, dynamic> _$PlanetToJson(Planet instance) => <String, dynamic>{
      'uid': instance.uid,
      'chunkSize': instance.chunkSize,
      'globalPosition': instance.globalPosition.toJson(),
      'radius': instance.radius,
      'spinSpeed': instance.spinSpeed,
      'satellitesCount': instance.satellitesCount,
      'isInitialPlanet': instance.isInitialPlanet,
      'satelliteMaxOrbitDistance': instance.satelliteMaxOrbitDistance,
      'satellites': instance.satellites.map((e) => e.toJson()).toList(),
      'saved': instance.saved,
      'terrain': instance.terrain.toJson(),
      'satellitesVersion': instance.satellitesVersion,
    };
