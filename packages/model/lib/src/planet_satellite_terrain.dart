import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';
import 'package:model/src/converter/array_bool.dart';

part 'planet_satellite_terrain.g.dart';

@JsonSerializable(explicitToJson: true)
class PlanetSatelliteTerrain {
  final int resolution;
  final int color;

  @JsonKey(toJson: arrayBoolToJson, fromJson: arrayBoolFromJson)
  final Array<bool> terrain;

  @JsonKey(toJson: arrayBoolToJson, fromJson: arrayBoolFromJson)
  final Array<bool> border;

  PlanetSatelliteTerrain({
    required this.resolution,
    required this.color,
    required this.terrain,
    required this.border,
  });

  factory PlanetSatelliteTerrain.fromJson(Map<String, dynamic> json) => _$PlanetSatelliteTerrainFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetSatelliteTerrainToJson(this);
}
