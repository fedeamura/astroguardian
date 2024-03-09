// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chunk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chunk _$ChunkFromJson(Map<String, dynamic> json) => Chunk(
      position: PointInt.fromJson(json['position'] as Map<String, dynamic>),
      planet: json['planet'] == null
          ? null
          : Planet.fromJson(json['planet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChunkToJson(Chunk instance) => <String, dynamic>{
      'position': instance.position.toJson(),
      'planet': instance.planet?.toJson(),
    };
