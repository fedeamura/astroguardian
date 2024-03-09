// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanetSummary _$PlanetSummaryFromJson(Map<String, dynamic> json) =>
    PlanetSummary(
      planets: (json['planets'] as List<dynamic>)
          .map((e) => PlanetSummaryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] as int,
    );

Map<String, dynamic> _$PlanetSummaryToJson(PlanetSummary instance) =>
    <String, dynamic>{
      'planets': instance.planets.map((e) => e.toJson()).toList(),
      'updatedAt': instance.updatedAt,
    };
