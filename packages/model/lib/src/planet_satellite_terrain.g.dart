// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_satellite_terrain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanetSatelliteTerrain _$PlanetSatelliteTerrainFromJson(
        Map<String, dynamic> json) =>
    PlanetSatelliteTerrain(
      resolution: json['resolution'] as int,
      color: json['color'] as int,
      terrain: arrayBoolFromJson(json['terrain'] as String),
      border: arrayBoolFromJson(json['border'] as String),
    );

Map<String, dynamic> _$PlanetSatelliteTerrainToJson(
        PlanetSatelliteTerrain instance) =>
    <String, dynamic>{
      'resolution': instance.resolution,
      'color': instance.color,
      'terrain': arrayBoolToJson(instance.terrain),
      'border': arrayBoolToJson(instance.border),
    };
