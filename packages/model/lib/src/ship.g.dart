// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ship _$ShipFromJson(Map<String, dynamic> json) => Ship(
      position: PointDouble.fromJson(json['position'] as Map<String, dynamic>),
      rotation: (json['rotation'] as num).toDouble(),
      rotationForce: (json['rotationForce'] as num).toDouble(),
      density: (json['density'] as num).toDouble(),
      moveForce: (json['moveForce'] as num).toDouble(),
      stopTime: (json['stopTime'] as num).toDouble(),
      abilities: mapShipAbilityFromJson(json['abilities'] as String),
      bag: json['bag'] as int,
      bagDistance: (json['bagDistance'] as num).toDouble(),
      pendingAbilityPoints: json['pendingAbilityPoints'] as int,
    );

Map<String, dynamic> _$ShipToJson(Ship instance) => <String, dynamic>{
      'position': instance.position.toJson(),
      'rotation': instance.rotation,
      'rotationForce': instance.rotationForce,
      'density': instance.density,
      'moveForce': instance.moveForce,
      'stopTime': instance.stopTime,
      'abilities': mapShipAbilityToJson(instance.abilities),
      'bagDistance': instance.bagDistance,
      'pendingAbilityPoints': instance.pendingAbilityPoints,
      'bag': instance.bag,
    };
