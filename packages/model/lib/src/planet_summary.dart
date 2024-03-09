import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'planet_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class PlanetSummary {
  final List<PlanetSummaryItem> planets;
  final int updatedAt;

  PlanetSummary({
    required this.planets,
    required this.updatedAt,
  });

  factory PlanetSummary.fromJson(Map<String, dynamic> json) => _$PlanetSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetSummaryToJson(this);
}
