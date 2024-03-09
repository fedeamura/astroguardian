// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanetInfo _$PlanetInfoFromJson(Map<String, dynamic> json) => PlanetInfo(
      uid: json['uid'] as String,
      position: PointDouble.fromJson(json['position'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      spinSpeed: (json['spinSpeed'] as num).toDouble(),
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );

Map<String, dynamic> _$PlanetInfoToJson(PlanetInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'position': instance.position.toJson(),
      'radius': instance.radius,
      'percentage': instance.percentage,
      'spinSpeed': instance.spinSpeed,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
