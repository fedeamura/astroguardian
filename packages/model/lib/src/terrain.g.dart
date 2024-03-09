// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terrain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terrain _$TerrainFromJson(Map<String, dynamic> json) => Terrain(
      type: $enumDecode(_$TerrainTypeEnumMap, json['type']),
      health: json['health'] as int,
      rarity: $enumDecode(_$TerrainRarityEnumMap, json['rarity']),
    );

Map<String, dynamic> _$TerrainToJson(Terrain instance) => <String, dynamic>{
      'type': _$TerrainTypeEnumMap[instance.type]!,
      'health': instance.health,
      'rarity': _$TerrainRarityEnumMap[instance.rarity]!,
    };

const _$TerrainTypeEnumMap = {
  TerrainType.none: 'none',
  TerrainType.dirt: 'dirt',
  TerrainType.energy: 'energy',
  TerrainType.asterium: 'asterium',
  TerrainType.ferronite: 'ferronite',
  TerrainType.plasmatite: 'plasmatite',
  TerrainType.quartzion: 'quartzion',
  TerrainType.starlume: 'starlume',
  TerrainType.vortexite: 'vortexite',
};

const _$TerrainRarityEnumMap = {
  TerrainRarity.normal: 'normal',
  TerrainRarity.rare: 'rare',
  TerrainRarity.ultra: 'ultra',
};
