import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'terrain.g.dart';

@JsonSerializable(explicitToJson: true)
class Terrain {
  TerrainType type;
  int health;
  TerrainRarity rarity;

  Terrain({
    required this.type,
    required this.health,
    required this.rarity,
  });

  bool consumeTerrain() {
    if (!type.canBeConsumed) return false;
    health = (health - 1).clamp(0, type.maxHealth);

    if (health <= 0) {
      type = TerrainType.none;
      health = TerrainType.none.maxHealth;

      return true;
    }

    return false;
  }

  factory Terrain.fromJson(Map<String, dynamic> json) => _$TerrainFromJson(json);

  Map<String, dynamic> toJson() => _$TerrainToJson(this);
}
