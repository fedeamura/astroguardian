// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_summary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanetSummaryItem _$PlanetSummaryItemFromJson(Map<String, dynamic> json) =>
    PlanetSummaryItem(
      uid: json['uid'] as String,
      position: PointDouble.fromJson(json['position'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      satelliteMaxOrbitDistance:
          (json['satelliteMaxOrbitDistance'] as num).toDouble(),
    );

Map<String, dynamic> _$PlanetSummaryItemToJson(PlanetSummaryItem instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'position': instance.position.toJson(),
      'radius': instance.radius,
      'satelliteMaxOrbitDistance': instance.satelliteMaxOrbitDistance,
    };
