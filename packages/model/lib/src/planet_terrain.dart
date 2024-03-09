import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';
import 'package:model/src/converter/array_double.dart';

part 'planet_terrain.g.dart';

@JsonSerializable(explicitToJson: true)
class PlanetTerrain {
  final double resolution;
  final List<String> colors;

  @JsonKey(toJson: arrayDoubleToJson, fromJson: arrayDoubleFromJson)
  final Array<double> terrain;

  @JsonKey(toJson: arrayDoubleToJson, fromJson: arrayDoubleFromJson)
  final Array<double> atmosphere;

  PlanetTerrain({
    required this.resolution,
    required this.colors,
    required this.terrain,
    required this.atmosphere,
  });

  factory PlanetTerrain.fromJson(Map<String, dynamic> json) => _$PlanetTerrainFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetTerrainToJson(this);
}
