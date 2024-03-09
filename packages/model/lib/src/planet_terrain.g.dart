// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_terrain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanetTerrain _$PlanetTerrainFromJson(Map<String, dynamic> json) =>
    PlanetTerrain(
      resolution: (json['resolution'] as num).toDouble(),
      colors:
          (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
      terrain: arrayDoubleFromJson(json['terrain'] as String),
      atmosphere: arrayDoubleFromJson(json['atmosphere'] as String),
    );

Map<String, dynamic> _$PlanetTerrainToJson(PlanetTerrain instance) =>
    <String, dynamic>{
      'resolution': instance.resolution,
      'colors': instance.colors,
      'terrain': arrayDoubleToJson(instance.terrain),
      'atmosphere': arrayDoubleToJson(instance.atmosphere),
    };
